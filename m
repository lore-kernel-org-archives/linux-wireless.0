Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64426 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933121AbaDINVN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 09:21:13 -0400
Received: by mail-pd0-f176.google.com with SMTP id r10so2432676pdi.7
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 06:21:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfcB7Uu9F2OHffOUy8mfUofMc38LS0GnShx7t0NADNckpg@mail.gmail.com>
References: <CAGm1_ktNAyqWhkTPycA-yKz9iXgqGvx3unjB7JHQpmiKFnFXuA@mail.gmail.com>
 <1396988949.4418.46.camel@dubbel> <CAGm1_ksFRCUNi1DPfmv=+8bBqiWxLSm6EeSYjhfVwR7oiAWBkw@mail.gmail.com>
 <1397035298.4418.60.camel@dubbel> <CAGm1_ktMWV0m1-gUTe8bQT1=f9HseBKCJn22bvPAgxynpeaQLg@mail.gmail.com>
 <1397044175.4418.66.camel@dubbel> <CA+XVXfcig5u1cQ8thxwO4B5_u=69x7FpdmORxMR4dFvpig_CZQ@mail.gmail.com>
 <1397047312.4418.68.camel@dubbel> <CA+XVXfcB7Uu9F2OHffOUy8mfUofMc38LS0GnShx7t0NADNckpg@mail.gmail.com>
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Wed, 9 Apr 2014 15:20:52 +0200
Message-ID: <CAGm1_kvwCoUT+EYTQy8bMda5fjnTz2seD25DP7Q1hfHyXtO5fw@mail.gmail.com> (sfid-20140409_152121_277590_41631A65)
Subject: Re: wl1271: tx stuck in firmware
To: Arik Nemtsov <arik@wizery.com>
Cc: Luca Coelho <luca@coelho.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	kaloz@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 9, 2014 at 3:07 PM, Arik Nemtsov <arik@wizery.com> wrote:
> On Wed, Apr 9, 2014 at 3:41 PM, Luca Coelho <luca@coelho.fi> wrote:
>>> Actually we've seen this bug before. At the time it was caused by FW
>>> requests for dummy packets during PLT mode, which forced us to issue
>>> Tx..
>>
>> Ah, interesting, I hadn't heard about it.  Would it send it even if the
>> event was masked out? Masking it out (if it's not already) for PLT would
>> probably be the right thing to do.
>>
>>
>>> It was fixed in the FW, but I'm not sure this was ever upstreamed
>>> (customer specific fix, etc). Anyway it's pretty safe to disable the
>>> Tx watchdog during PLT - try something like this:
>>>
>>> void wl12xx_rearm_tx_watchdog_locked(struct wl1271 *wl)
>>> {
>>>      if (wl->plt)
>>>          return;
>>
>> Maybe this could be blocked even earlier, like here:
>>
>> diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
>> index 1f9a360..c44d3c0 100644
>> --- a/drivers/net/wireless/ti/wlcore/event.c
>> +++ b/drivers/net/wireless/ti/wlcore/event.c
>> @@ -158,6 +158,9 @@ EXPORT_SYMBOL_GPL(wlcore_event_channel_switch);
>>
>>  void wlcore_event_dummy_packet(struct wl1271 *wl)
>>  {
>> +       if (wl->plt)
>> +               return;
>> +
>>         wl1271_debug(DEBUG_EVENT, "DUMMY_PACKET_ID_EVENT_ID");
>>         wl1271_tx_dummy_packet(wl);
>>  }
>>
>> --
>> Luca.
>>
>
> These are good suggestions as well.

Both changes helped a lot. At least one can make a lot of tests
without a crash, though I had one

# calibrator wlan0 plt tune_channel 0 1
# calibrator wlan0 plt tx_tone 1 9000
[  180.041505] wlcore: ERROR command complete timeout
[  180.046622] ------------[ cut here ]------------
[  180.051756] WARNING: CPU: 0 PID: 1072 at
drivers/net/wireless/ti/wlcore/main.c:803
wl12xx_queue_recovery_work+0x60/0x6c()
[  180.063451] Modules linked in:
[  180.066734] CPU: 0 PID: 1072 Comm: calibrator Not tainted
3.14.0-rc4-12739-g17534e5-dirty #251
[  180.075991] [<c00151e0>] (unwind_backtrace) from [<c0011e38>]
(show_stack+0x10/0x14)
[  180.084311] [<c0011e38>] (show_stack) from [<c05c57d4>]
(dump_stack+0x7c/0x94)
[  180.092062] [<c05c57d4>] (dump_stack) from [<c0040274>]
(warn_slowpath_common+0x6c/0x90)
[  180.100721] [<c0040274>] (warn_slowpath_common) from [<c0040334>]
(warn_slowpath_null+0x1c/0x24)
[  180.110028] [<c0040334>] (warn_slowpath_null) from [<c038de68>]
(wl12xx_queue_recovery_work+0x60/0x6c)
[  180.119976] [<c038de68>] (wl12xx_queue_recovery_work) from
[<c0390710>] (wlcore_cmd_send_failsafe+0x74/0x420)
[  180.130596] [<c0390710>] (wlcore_cmd_send_failsafe) from
[<c0390b30>] (wl1271_cmd_test+0x4c/0x9c)
[  180.140005] [<c0390b30>] (wl1271_cmd_test) from [<c03a0184>]
(wl1271_tm_cmd+0x370/0x5ac)
[  180.148740] [<c03a0184>] (wl1271_tm_cmd) from [<c055a710>]
(nl80211_testmode_do+0x94/0x148)
[  180.157698] [<c055a710>] (nl80211_testmode_do) from [<c0496434>]
(genl_rcv_msg+0x224/0x390)
[  180.166635] [<c0496434>] (genl_rcv_msg) from [<c0495a1c>]
(netlink_rcv_skb+0xc4/0xd8)
[  180.175015] [<c0495a1c>] (netlink_rcv_skb) from [<c04961fc>]
(genl_rcv+0x20/0x34)
[  180.183023] [<c04961fc>] (genl_rcv) from [<c0495364>]
(netlink_unicast+0x15c/0x22c)
[  180.191219] [<c0495364>] (netlink_unicast) from [<c0495794>]
(netlink_sendmsg+0x2bc/0x37c)
[  180.199974] [<c0495794>] (netlink_sendmsg) from [<c045f950>]
(sock_sendmsg+0x84/0xa8)
[  180.208360] [<c045f950>] (sock_sendmsg) from [<c0460ea8>]
(___sys_sendmsg.part.28+0x268/0x278)
[  180.217568] [<c0460ea8>] (___sys_sendmsg.part.28) from [<c0461f10>]
(__sys_sendmsg+0x4c/0x7c)
[  180.226686] [<c0461f10>] (__sys_sendmsg) from [<c000e2c0>]
(ret_fast_syscall+0x0/0x48)
[  180.235143] ---[ end trace c13b2d4f8f45be2b ]---
[  180.241635] wlcore: WARNING TEST command failed
[  180.246453] wlcore: WARNING testmode cmd test failed: -110
command failed: Connection timed out (-110)

But after reboot I could successfully invoke calibrator wlan0 plt tx_tone 1 9000
