Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:63616 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab3HDPBs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Aug 2013 11:01:48 -0400
Received: by mail-qa0-f45.google.com with SMTP id l18so527561qak.11
        for <linux-wireless@vger.kernel.org>; Sun, 04 Aug 2013 08:01:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJZjf_zA+GyL9Wu3rKaNpU6Sn6_zO+Ng6T2S4Y=Y4rJjzA6RiQ@mail.gmail.com>
References: <20130603141804.GA2146@redhat.com> <CAJZjf_xoCOTFsLAB29uLKeW7+O+k255Amspn6GKFMysc7CTsBg@mail.gmail.com>
 <CAJZjf_xGdvStOG0=FR2+2WsVcjyizQukH+RxysZf8f9-Tk9L9w@mail.gmail.com>
 <20130611161924.GB1696@redhat.com> <CAJZjf_zOF=qGEE=pWDRe0YDpAYophm93cVM8pfuL0sTRGq56EA@mail.gmail.com>
 <20130614131829.GA5125@redhat.com> <20130625142514.GA1938@redhat.com>
 <CAJZjf_z=+QW_Y3yuz6nJ+muVA_6bGRut8EQ7fCopDqqj2Fn9Yw@mail.gmail.com>
 <20130716102743.GA8321@redhat.com> <CAJZjf_y9fnkHLp4YPdYY2sVo4r4+hKJcZAebJmjVKCBh-0EUtA@mail.gmail.com>
 <20130731120848.GA31732@redhat.com> <CAJZjf_zA+GyL9Wu3rKaNpU6Sn6_zO+Ng6T2S4Y=Y4rJjzA6RiQ@mail.gmail.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Sun, 4 Aug 2013 15:53:14 +0100
Message-ID: <CAJZjf_x3xwMijn5Jjc0qAaFdzq-4sH-gtm+hv5jKVpFCSBu0=Q@mail.gmail.com> (sfid-20130804_170151_817889_59085721)
Subject: Re: Power saving features for iwl4965
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Tino Keitel <tino.keitel@tikei.de>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 4, 2013 at 3:24 PM, Pedro Francisco
<pedrogfrancisco@gmail.com> wrote:
> On Wed, Jul 31, 2013 at 1:08 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> On Wed, Jul 17, 2013 at 12:48:30PM +0100, Pedro Francisco wrote:
>>> On Tue, Jul 16, 2013 at 11:27 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>>> >> I seem only to be able to trigger it with disable_hw_scan=0, I need
>>> >> further testing with disable_hw_scan=1 (I use disable_hw_scan=0
>>> >> because it prevents me from getting disconnected from eduroam Cisco
>>> >> APs -- haven't tested disable_hw_scan=0 since the VOIP-friendly SW
>>> >> scanning patch, however).
>>> >>
>>> >> Do you want the log anyway? (modprobe iwl3945 debug=0x47ffffff
>>> >> disable_hw_scan=0 and runtime PCI powersave also enabled -- I don't
>>> >> know if it matters).
>>> >
>>> > As this is not causing troubles with default disable_hw_scan option,
>>> > I'll post that patch.
>>>
>>> My mistake, I can trigger error conditions _independently_ of
>>> disable_hw_scan option being enabled or disabled, as long as powersave
>>> is enabled.
>>>
>>> I'll send you a private email with the logs.
>>
>> I think I found bug which couse this firmware crash. We have only 5
>> queues so updating write_ptr for txq[5] can cause random value write
>> to HBUS_TARG_WRPTR register. I also added spin_lock to do not abuse
>> writes we do in tx skb.
>>
>> Please test attached patch (with powersave on :-)
>
> Still not working :( I tested for two nights, first one was fine,
> second was not (the only difference was I had kernel parameter
> `slub_debug` on the second night, but my guess it shouldn't affect
> anything?).
>
> Snippet of log follows, full logs I'll send privately (beware,
> unzipped it's 423MB).
>
> Anyway, any idea what is the value 0xa5a5a5a2 ? It's always the same
> value which makes the reloaded firmware to fail... And in other
> firmware failures around the Web, both iwlegacy and iwlwifi.
>
> Aug  4 09:23:58 s2 kernel: [32309.937084] iwl3945 0000:02:00.0: Queue
> 4 stuck for 2004 ms.
> Aug  4 09:23:58 s2 kernel: [32309.937106] iwl3945 0000:02:00.0: On
> demand firmware reload
> Aug  4 09:23:58 s2 kernel: [32309.937128] ieee80211 phy1: U
> __il3945_down iwl3945 is going down
> Aug  4 09:23:58 s2 kernel: [32309.937137] ieee80211 phy1: U
> il_scan_cancel_timeout Scan cancel timeout
> Aug  4 09:23:58 s2 kernel: [32309.937143] ieee80211 phy1: U
> il_do_scan_abort Not performing scan to abort
> Aug  4 09:23:58 s2 kernel: [32309.937149] ieee80211 phy1: U
> il_clear_ucode_stations Clearing ucode stations in driver
> Aug  4 09:23:58 s2 kernel: [32309.937155] ieee80211 phy1: U
> il_clear_ucode_stations Clearing ucode active for station 0
> Aug  4 09:23:58 s2 kernel: [32309.937162] ieee80211 phy1: U
> il_clear_ucode_stations Clearing ucode active for station 24
> Aug  4 09:23:58 s2 kernel: [32309.938116] ieee80211 phy1: U
> _il_apm_stop Stop card, put in low power state
> Aug  4 09:23:58 s2 kernel: [32309.938116] iwl3945 0000:02:00.0: Master
> Disable Timed Out, 100 usec
> Aug  4 09:23:58 s2 kernel: [32309.938116] ieee80211 phy1: U
> _il_apm_stop_master stop master
> Aug  4 09:23:58 s2 kernel: [32309.954705] ieee80211 phy1: U
> il3945_clear_free_frames 0 frames on pre-allocated heap on clear.
> Aug  4 09:23:58 s2 kernel: [32309.954740] ieee80211 phy1: Hardware
> restart was requested
> Aug  4 09:23:58 s2 kernel: [32309.954757] ieee80211 phy1: U
> il3945_mac_start enter
> Aug  4 09:23:58 s2 kernel: [32309.954763] ieee80211 phy1: U
> il_prep_station Add STA to driver ID 24: ff:ff:ff:ff:ff:ff
> Aug  4 09:23:58 s2 kernel: [32309.954774] ieee80211 phy1: U
> il_apm_init Init card's basic functions
> Aug  4 09:23:58 s2 kernel: [32309.955111] ieee80211 phy1: U
> il3945_nic_config HW Revision ID = 0x2
> Aug  4 09:23:58 s2 kernel: [32309.955117] ieee80211 phy1: U
> il3945_nic_config 3945 RADIO-MM type
> Aug  4 09:23:58 s2 kernel: [32309.955127] ieee80211 phy1: U
> il3945_nic_config SKU OP mode is basic
> Aug  4 09:23:58 s2 kernel: [32309.955131] ieee80211 phy1: U
> il3945_nic_config 3945ABG revision is 0xF1
> Aug  4 09:23:58 s2 kernel: [32309.955140] ieee80211 phy1: U
> il3945_nic_config Card M type B version is 0x3
> Aug  4 09:23:58 s2 kernel: [32309.955150] ieee80211 phy1: U
> il3945_nic_config SW RF KILL supported in EEPROM.
> Aug  4 09:23:58 s2 kernel: [32309.955153] ieee80211 phy1: U
> il3945_nic_config HW RF KILL supported in EEPROM.
> Aug  4 09:23:58 s2 kernel: [32309.974318] ieee80211 phy1: U
> il3945_load_bsm Begin load bsm
> Aug  4 09:23:58 s2 kernel: [32310.018857] ieee80211 phy1: U
> il3945_verify_bsm Begin verify bsm
> Aug  4 09:23:58 s2 kernel: [32310.020628] iwl3945 0000:02:00.0: BSM
> uCode verification failed at addr 0x00003800+0 (of 900), is
> 0xa5a5a5a2, s/b 0xf802020
> Aug  4 09:23:58 s2 kernel: [32310.020632] iwl3945 0000:02:00.0: Unable
> to set up bootstrap uCode: -5
> Aug  4 09:23:58 s2 kernel: [32310.020636] ieee80211 phy1: U
> il3945_load_bsm Begin load bsm
> Aug  4 09:23:58 s2 kernel: [32310.041691] hrtimer: interrupt took 3021833 ns
> Aug  4 09:23:58 s2 kernel: [32310.065681] ieee80211 phy1: U
> il3945_verify_bsm Begin verify bsm
> Aug  4 09:23:58 s2 kernel: [32310.067345] iwl3945 0000:02:00.0: BSM
> uCode verification failed at addr 0x00003800+0 (of 900), is
> 0xa5a5a5a2, s/b 0xf802020

Other thing, which may or may not be relevant. The 'script':
rmmod iwl3945; modprobe iwl3945 debug=0x47ffffff ; sleep 10; rmmod
iwl3945; modprobe iwl3945

At the end of this 'script', shouldn't debug mode be disabled? I
thought it would be disabled, but until `modprobe iwl3945 debug=0` is
done, debug is still active. Does this mean firmware reload/module
reload isn't completely resetting the card, as I suppose it was
supposed to do?

-- 
Pedro
