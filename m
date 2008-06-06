Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:37262 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYFFX7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 19:59:49 -0400
Received: by wa-out-1112.google.com with SMTP id j37so910737waf.23
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jun 2008 16:59:48 -0700 (PDT)
Message-ID: <1ba2fa240806061659j7672f9d3w107be4509b533f68@mail.gmail.com> (sfid-20080607_020018_361726_635359E2)
Date: Sat, 7 Jun 2008 02:59:48 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Thomas Backlund" <tmb@mandriva.org>
Subject: Re: iwl4965 oops in 2.6.26-rc5 x86_64
Cc: "Ian Schram" <ischram@telenet.be>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4849AF9F.9010207@mandriva.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4848289D.1080205@mandriva.org> <48485F12.2050908@mandriva.org>
	 <48488878.5040708@telenet.be>
	 <1ba2fa240806060432t73ecb318x89e877241aa6ef55@mail.gmail.com>
	 <48492734.9080901@mandriva.org> <48492E85.6010307@mandriva.org>
	 <1ba2fa240806060659wf4e4088s8afdd2f7f854ea09@mail.gmail.com>
	 <48494EF6.4020506@mandriva.org>
	 <1ba2fa240806060812q28c270c4i12cc08f8665e9cc0@mail.gmail.com>
	 <4849AF9F.9010207@mandriva.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 7, 2008 at 12:43 AM, Thomas Backlund <tmb@mandriva.org> wrote:
> Tomas Winkler skrev:
>>
>> On Fri, Jun 6, 2008 at 5:51 PM, Thomas Backlund <tmb@mandriva.org> wrote:
>>>
>>> Tomas Winkler skrev:
>>>>
>>>> On Fri, Jun 6, 2008 at 3:33 PM, Thomas Backlund <tmb@mandriva.org>
>>>> wrote:
>>>>>
>>>>> Thomas Backlund skrev:
>>>>>>
>>>>>> Tomas Winkler skrev:
>>>>>>>
>>>>>>> On Fri, Jun 6, 2008 at 3:44 AM, Ian Schram <ischram@telenet.be>
>>>>>>> wrote:
>>>>>>>>
>>>>>>>> Isn't this the Oops Joonwoo Park wanted to patch with
>>>>>>>>
>>>>>>>> "[PATCH] iwlwifi: fix oops on wep key insertion" 27/5/2008
>>>>>>>>
>>>>>>>> invalid length of webkey that would/should be handled in mac80211?
>>>>>>>>
>>>>>>>> ian
>>>>>>>
>>>>>>> Yes, it looks like.
>>>>>>
>>>>>> Ummm, what has a wep key to do with me trying to access a
>>>>>> WPA2-Personal
>>>>>> encrypted net ?
>>>>
>>>> Not sure yet, but mac is trying to assign default/static wep key.
>>>>
>>>> :iwlcore:iwl_send_static_wepkey_cmd+0xcb/0xd5
>>>> :iwlcore:iwl_set_default_wep_key+0xa2/0xbc
>>>>
>>>> Try to set the encryption explicitly
>>>> network={
>>>>   psk="*************************"
>>>>   scan_ssid=1
>>>>   ssid="dlink"
>>>>   pairwise=CCMP
>>>>  group=CCMP
>>>>  }
>>>>
>>>>
>>> That didn't help at all.
>>>
>>> What's more it prevented the wifi to work on 2.6.24.7 so I had to remove
>>> the
>>> lines again...
>>>
>> So what's your AP configuration TKIP?
>>
>
> I've switched to clean WPA2-AES on the AP, but it does not do any
> difference... I still get the oops...
>

I would like to see the log of this one

>> Second try also with sw decryption:
>>
>> in /etc/modprobe.conf
>> options iwl4965 swcrypto=1
>>
>
>
> That works.
> I now run a clean 2.6.26-rc5
>
Okay thanks for checking this one.
>

> I also tried to bisect between 2.6.25 and 2.6.26-rc1 and ended up with:
>
> [root@5720g linux-2.6]# git bisect good
> 8318d78a44d49ac1edf2bdec7299de3617c4232e is first bad commit
> commit 8318d78a44d49ac1edf2bdec7299de3617c4232e
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Thu Jan 24 19:38:38 2008 +0100
>
>    cfg80211 API for channels/bitrates, mac80211 and driver conversion
>
>
>
> Any more I can provide to help finding the bug ?

Just the log from AES try with  I will try to reproduce this as soon
as I get to this particular AP and 64 bits kernel.

One more thing is suspicious in the WEP key try is that I don't see
this can ever happen. The command that should be here iis
wlcore:iwl_send_cmd_async
Jun  5 19:55:06 5720g kernel:  [<ffffffffa018ee37>]
:iwlcore:iwl_send_cmd_sync+0x94/0x257
Jun  5 19:55:06 5720g kernel:  [<ffffffff80257ed5>] ? __lock_acquire+0xbee/0xd5a
Jun  5 19:55:06 5720g kernel:  [<ffffffffa018f04b>]
:iwlcore:iwl_send_cmd+0x16/0x1b
Jun  5 19:55:06 5720g kernel:  [<ffffffffa0218c41>]
:iwl4965:iwl_send_static_wepkey_cmd+0xcb/0xd5
Jun  5 19:55:06 5720g kernel:  [<ffffffffa0218cef>]
:iwl4965:iwl_set_default_wep_key+0xa4/0xbe
Jun  5 19:55:06 5720g kernel:  [<ffffffffa020ae00>]
:iwl4965:iwl4965_mac_set_key+0xf1/0x137

The code there looks like this

int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
{
	int i, not_empty = 0;
	u8 buff[sizeof(struct iwl_wep_cmd) +
		sizeof(struct iwl_wep_key) * WEP_KEYS_MAX];
	struct iwl_wep_cmd *wep_cmd = (struct iwl_wep_cmd *)buff;
	size_t cmd_size  = sizeof(struct iwl_wep_cmd);
	struct iwl_host_cmd cmd = {
		.id = REPLY_WEPKEY,
		.data = wep_cmd,
		.meta.flags = CMD_ASYNC, -----------------------------------------
this is async
	};

Thanks
Tomas
