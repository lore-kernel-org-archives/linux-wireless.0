Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25422 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbaKSIt4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 03:49:56 -0500
From: Avinash Patil <patila@marvell.com>
To: Martin Fuzzey <mfuzzey@parkeon.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 19 Nov 2014 00:44:28 -0800
Subject: RE: [REGRESSION] mwifiex: memory corruption on WEP disassociation
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC666FA7DC8F@SC-VEXCH2.marvell.com> (sfid-20141119_094959_977526_55550866)
References: <546B5E82.7000207@parkeon.com>,<20141118184241.GD13458@tuxdriver.com>
 <CBACCFA0AEB13A41977475BCF3E896FC666FA7DC82@SC-VEXCH2.marvell.com>,<546C57AF.1040700@parkeon.com>
In-Reply-To: <546C57AF.1040700@parkeon.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Martin,

If v1 is being used which can be case because older FWs dont have support for keymaterial v2, I suspect FW is returning bad length.

>>I've noticied that there is a more recent firmware version available in
the Marvell git repository but that it doesn't seem to have propagated
to the linux-firmware repository.
Are there any firmware changelogs avaliable?

Yes; 14.66.35.p52 FW has yet not propagated to linux-firmware.
Could you please check if issue is seen with this FW as well?
Here is link:
http://git.marvell.com/?p=mwifiex-firmware.git;a=commit;h=3f45b8c4cc1eb1d102bc3486b19677332dd215ab

>>Thinking about this some more I've realized that, in addition to this
issue, even if the whole response message does come from the firmware,
the kernel is trusting the key size provided, even if that means
overwriting memory. Probably not a good idea in the event of the
possibility of buggy or malicious firmware...

Yes; we need to have a check for command length/TLV length less than maximum command response size.
We will add this check.

Thanks,
Avinash
________________________________________
From: Martin Fuzzey [mfuzzey@parkeon.com]
Sent: Wednesday, November 19, 2014 2:11 PM
To: Avinash Patil
Cc: John W. Linville; linux-wireless@vger.kernel.org; Amitkumar Karwar
Subject: Re: [REGRESSION] mwifiex: memory corruption on WEP disassociation

Hi Avinash,

Thanks for the quick reply.

On 19/11/14 05:40, Avinash Patil wrote:
> Hi Martin,
>
> Thanks for reporting this issue.
>
> What is chipset and FW you are using? Are you using same FW on both 3.13 and 3.16?
> Key material v2 was introduced somewhere between 3.13 to 3.16 which may have caused this issue.

Chipset is SD8787  (on a Lesswire Wiibear11n SDIO wifi module).

We are using firware 14.66.9.p96  (with both 3.13 an 3.16 kernels)
On 3.16 the v1 key materiel is being used.

I've noticied that there is a more recent firmware version available in
the Marvell git repository but that it doesn't seem to have propagated
to the linux-firmware repository.
Are there any firmware changelogs avaliable?

Thinking about this some more I've realized that, in addition to this
issue, even if the whole response message does come from the firmware,
the kernel is trusting the key size provided, even if that means
overwriting memory. Probably not a good idea in the event of the
possibility of buggy or malicious firmware...

> We will look into this.
Thank you,


Martin

>
> Thanks,
> Avinash
> ________________________________________
> From: John W. Linville [linville@tuxdriver.com]
> Sent: Wednesday, November 19, 2014 12:12 AM
> To: Martin Fuzzey
> Cc: linux-wireless@vger.kernel.org; Avinash Patil; Amitkumar Karwar
> Subject: Re: [REGRESSION] mwifiex: memory corruption on WEP disassociation
>
> FWIW, Bing has moved-on...  Hopefully Avinash and Amitkumar are
> available to look at this?
>
> On Tue, Nov 18, 2014 at 03:58:10PM +0100, Martin Fuzzey wrote:
>> Hello,
>>
>> I have discovered a problem in mwifiex in kernel 3.16.
>>
>> Connection to a WEP access point works correctly, however disassociation
>> results in corruption of the mwifiex data structures leading to an oops or a
>> panic.
>>
>> The problem does not occur in 3.13. I have not yet been able to test more
>> recent kernels but the git logs do not seem to indicate any fixes for this.
>>
>>
>> The memory corruption occurs in mwifiex_ret_802_11_key_material_v1() when a
>> short command response is received without a key length causing non
>> initialised memory to be interpreted as the key length resulting in a
>> memcpy() overwriting the part of the driver's private data structure beyond
>> the key area.
>>
>> Here are some added logs showing the problem:
>>
>> Associate:   (OK, response size 0x23 includes key)
>> [   57.212848] @MF@ mwifiex_sec_ioctl_set_wep_key len=0xd disable=0 index=0
>> [   57.225068] keyReqCmd 00000000: 5e 00 23 00 00 00 00 00 01 00 00 01 15 00
>> 00 00  ^.#.............
>> [   57.233965] keyReqCmd 00000010: 07 00 0d 00 00 01 20 14 02 27 89 01 23 45
>> 67 89  ...... ..'..#Eg.
>> [   57.242848] keyReqCmd 00000020: 01 23 45
>> .#E
>> [   57.269746] keyV1Resp 00000000: 01 00 00 01 15 00 00 00 07 00 0d 00 00 01
>> 20 14  .............. .
>> [   57.278631] keyV1Resp 00000010: 02 27 89 01 23 45 67 89 01 23 45 00 10 01
>> 0a 00  .'..#Eg..#E.....
>> [   57.287522] keyV1Resp 00000020: 02 01 00 00 00 00 00 00 00 00 10 01 0a 00
>> 03 01  ................
>> [   57.296411] keyV1Resp 00000030: 00 00 00 00 00 00 00 00 4a 00 80 00 00 13
>> ........J.....
>> [   57.305134] @MF@ mwifiex_ret_802_11_key_material_v1: result=0 size=0x23
>> seqno=66 initialize dd4c43b8 zerolen=0032 datalen=000d)
>>
>>
>> Disassociate:  (Bad: response size 0xa too small)
>> [   66.272751] @MF@ mwifiex_sec_ioctl_set_wep_key len=0xd disable=1 index=0
>> [   66.284952] keyReqCmd 00000000: 5e 00 0a 00 00 00 00 00 01 00
>> ^.........
>> [   66.312306] keyV1Resp 00000000: 01 00 9a 7f 59 80 00 00 00 01 33 33 00 00
>> 00 01  ....Y.....33....
>> [   66.321180] keyV1Resp 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00  ................
>> [   66.330070] keyV1Resp 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00  ................
>> [   66.338959] keyV1Resp 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> ..............
>>
>> Here the response size if only 10 bytes so the rest of the buffer is
>> invalid, causing the key length to be conisdered to be 0x3333 ....
>> [   66.347672] @MF@ mwifiex_ret_802_11_key_material_v1: result=0 size=0xa
>> seqno=88 initialize dd4c43b8 zerolen=0032 datalen=3333)
>>
>>
>>
>> Similar traces on a 3.13 kernel:
>>
>> Associate:
>> [   83.165599] @MF@ mwifiex_sec_ioctl_set_wep_key len=0x0 disable=1 index=0
>> [   83.189847] keyReqCmd 00000000: 5e 00 23 00 00 00 00 00 01 00 00 01 15 00
>> 00 00  ^.#.............
>> [   83.198736] keyReqCmd 00000010: 07 00 0d 00 00 01 20 14 02 27 89 01 23 45
>> 67 89  ...... ..'..#Eg.
>> [   83.207619] keyReqCmd 00000020: 01 23 45
>> .#E
>> [   83.215997] @MF@ mwifiex_ret_802_11_key_material: result=0 size=0x23
>> seqno=50
>> [   83.223171] keyV1Resp 00000000: 01 00 00 01 15 00 00 00 07 00 0d 00 00 01
>> 20 14  .............. .
>> [   83.232057] keyV1Resp 00000010: 02 27 89 01 23 45 67 89 01 23 45 12 01 01
>> 00 20  .'..#Eg..#E....
>> [   83.240940] keyV1Resp 00000020: 02 01 02 00 01 00 2d 00 1a 00 7e 01 03 ff
>> 00 00  ......-...~.....
>> [   83.249813] keyV1Resp 00000030: 00 01 00 00 00 00 00 00 00 01 00 00 00 00
>> ..............
>>
>> Disassociate:
>> [   98.538391] @MF@ mwifiex_sec_ioctl_set_wep_key len=0xd disable=1 index=0
>>
>> Here we send the key again even though we are disabling it....
>> [   98.545188] keyReqCmd 00000000: 5e 00 23 00 00 00 00 00 01 00 00 01 15 00
>> 00 00  ^.#.............
>> [   98.554283] keyReqCmd 00000010: 07 00 0d 00 00 01 20 14 02 27 89 01 23 45
>> 67 89  ...... ..'..#Eg.
>> [   98.563175] keyReqCmd 00000020: 01 23 45
>> .#E
>>
>> And we get a full response.
>> [   98.571580] @MF@ mwifiex_ret_802_11_key_material: result=0 size=0x23
>> seqno=94
>> [   98.578729] keyV1Resp 00000000: 01 00 00 01 15 00 00 00 07 00 0d 00 00 01
>> 20 14  .............. .
>> [   98.587636] keyV1Resp 00000010: 02 27 89 01 23 45 67 89 01 23 45 00 00 00
>> 00 00  .'..#Eg..#E.....
>> [   98.596521] keyV1Resp 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00  ................
>> [   98.605405] keyV1Resp 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> ..............
>>
>>
>> The reason for the difference appears to be this code in
>> mwifiex_sec_ioctl_set_wep_key()
>>
>>          if (encrypt_key->key_disable)
>>              memset(&priv->wep_key[index], 0,
>>                     sizeof(struct mwifiex_wep_key));
>>
>>
>> The zeroing of the key means causes mwifiex_set_keyparamset_wep() to not
>> find any keys and the command sent to not include them.
>>
>> Not knowing the firmware interface I don't know if this is correct or not
>> (ie is the real problem the command sent or the handling of the result?)
>>
>> For the moment this workaround "fixes" the problem for me:    (hack patch,
>> probably white space broken)
>>
>> diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c
>> b/drivers/net/wireless/mwifiex/sta_cmdresp.c
>> index 577f297..e50c9fe 100644
>> --- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
>> +++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
>> @@ -591,6 +591,14 @@ static int mwifiex_ret_802_11_key_material_v1(struct
>> mwifiex_private *priv,
>>
>>          memset(priv->aes_key.key_param_set.key, 0,
>>                 sizeof(key->key_param_set.key));
>> +
>> +       if (le16_to_cpu(resp->size) <
>> +               (S_DS_GEN + sizeof(key->action) + offsetof(struct
>> mwifiex_ie_type_key_param_set, key))) {
>> +
>> +               printk(KERN_WARNING "@MF@ %s: ignoring short response\n",
>> __func__);
>> +               return 0;
>> +       }
>> +
>>          priv->aes_key.key_param_set.key_len = key->key_param_set.key_len;
>>          memcpy(priv->aes_key.key_param_set.key, key->key_param_set.key,
>>                 le16_to_cpu(priv->aes_key.key_param_set.key_len));
>> @@ -624,6 +632,14 @@ static int mwifiex_ret_802_11_key_material_v2(struct
>> mwifiex_private *priv,
>>
>>          memset(priv->aes_key_v2.key_param_set.key_params.aes.key, 0,
>>                 WLAN_KEY_LEN_CCMP);
>> +
>> +       if (le16_to_cpu(resp->size) <
>> +               (S_DS_GEN + sizeof(key_v2->action) + offsetof(struct
>> mwifiex_ie_type_key_param_set_v2, key_params))) {
>> +
>> +               printk(KERN_WARNING "@MF@ %s: ignoring short response\n",
>> __func__);
>> +               return 0;
>> +       }
>> +
>>          priv->aes_key_v2.key_param_set.key_params.aes.key_len =
>> key_v2->key_param_set.key_params.aes.key_len;
>>          len = priv->aes_key_v2.key_param_set.key_params.aes.key_len;
>>
>>
>> Regards,
>>
>> Martin Fuzzey
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
