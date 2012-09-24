Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:37508 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab2IXOkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 10:40:37 -0400
Received: by oago6 with SMTP id o6so5456753oag.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2012 07:40:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEZZmbG78oO5_D3zncanXStYpuf_faoqq6rp3usPpd3_5+tBQA@mail.gmail.com>
References: <CC53EBAA.16239%sunil2@telenetsystems.com>
	<503318FD.7070108@qca.qualcomm.com>
	<CAEZZmbG78oO5_D3zncanXStYpuf_faoqq6rp3usPpd3_5+tBQA@mail.gmail.com>
Date: Mon, 24 Sep 2012 20:10:36 +0530
Message-ID: <CAD2nsn3h+_SCG8HBzNT_onAN-Tg2qVDBbYrpTHM8LRFX+Z-wTg@mail.gmail.com> (sfid-20120924_164041_140093_9FEC9583)
Subject: Re: [ath9k-devel] :
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ravi Sharma <sharmaravi.lx@gmail.com>
Cc: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Sunil Mehta <sunil2@telenetsystems.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Mohammed@venema.h4ckr.net,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org,
	Felix Bitterli <felixb@qca.qualcomm.com>
Content-Type: multipart/mixed; boundary=f46d04479f7795540504ca739249
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--f46d04479f7795540504ca739249
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Sep 20, 2012 at 4:07 PM, Ravi Sharma <sharmaravi.lx@gmail.com> wrote:
> Hi,
>
> I am trying to setup concurrent mode for TL-WL722N (TP-LINK) (ath9k)
> and upgraded& used the driver with the latest compat release. I am
> trying to run STA & P2P concurrently with two supplicant. Is this
> configuration possible?

yes.
please note you goto add vif1 as a virtual STA interface using
interface add command

./wpa_supplicant  -i vif1 -c wpa_supplicant/open-con.conf -N  -i wlan1
   -c ./wpa_supplicant/p2p.conf

http://wireless.kernel.org/en/developers/p2p/howto

PFA

>
>
>
> I am using Ubuntu with kernel 3.2

please use the latest compat, but there are issues with p2p concurrency
for p2p-go incase the STA scans

>
> Can you please share the setup you are using to validate the ath9k
> mac80211 for concurrent mode?
>
> Regards,
> Ravi
>
> On Tue, Aug 21, 2012 at 10:43 AM, Mohammed Shafi Shajakhan
> <mohammed@qca.qualcomm.com> wrote:
>> Hi,
>>
>>
>> On Friday 17 August 2012 12:42 PM, Sunil Mehta wrote:
>>>>
>>>>
>>>> Hi
>>>
>>>
>>> We are using AR9331 and are currently using the device in - AP mode, and
>>> Station mode.
>>>
>>> We would like to use the device for a P2P application. Can you suggest
>>> what we need to do.
>>
>>
>> sorry for the delayed reply, i was on leave(did not check any mails!) for
>> the past 6 days.
>>
>> please read this and check this out, if it helps and works for you
>> http://linuxwireless.org/en/developers/p2p/howto.
>>
>> please let me know if there any basic configuration issues.
>>
>> technical issues related to p2p are discussed in hostap mailing lists
>> http://lists.shmoo.com/mailman/listinfo/hostap
>>
>>
>>
>>>
>>> Regards,
>>> Sunil.
>>>
>>>
>>
>>
>> --
>> thanks,
>> shafi
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi

--f46d04479f7795540504ca739249
Content-Type: application/octet-stream; name="open-con.conf"
Content-Disposition: attachment; filename="open-con.conf"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h7honrpr0

Y3RybF9pbnRlcmZhY2U9L3Zhci9ydW4vd3BhX3N1cHBsaWNhbnQKbmV0d29yaz17Cglzc2lkPSJB
VEg5Sy01RyIKCWtleV9tZ210PU5PTkUKfQoKCg==
--f46d04479f7795540504ca739249
Content-Type: application/octet-stream; name="p2p.conf"
Content-Disposition: attachment; filename="p2p.conf"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h7honz0o1

Y3RybF9pbnRlcmZhY2U9L3Zhci9ydW4vd3BhX3N1cHBsaWNhbnQKYXBfc2Nhbj0xCgpkZXZpY2Vf
bmFtZT1OYWRhbC1wMnAtZGV2aWNlCmRldmljZV90eXBlPTEtMDA1MEYyMDQtMQoKIyBJZiB5b3Ug
bmVlZCB0byBtb2RpZnkgdGhlIGdyb3VwIG93bmVyIGludGVudCwgMC0xNSwgdGhlIGhpZ2hlcgoj
IG51bWJlciBpbmRpY2F0ZXMgcHJlZmVyZW5jZSB0byBiZWNvbWUgdGhlIEdPLiBZb3UgY2FuIGFs
c28gc2V0CiMgdGhpcyBvbiBwMnBfY29ubmVjdCBjb21tYW5kcy4KI3AycF9nb19pbnRlbnQ9OAoK
IyBvcHRpb25hbCwgY2FuIGJlIHVzZWZ1bCBmb3IgbW9uaXRvcmluZywgZm9yY2VzCiMgd3BhX3N1
cHBsaWNhbnQgdG8gdXNlIG9ubHkgY2hhbm5lbCAxIHJhdGhlciB0aGFuCiMgMSwgNiBhbmQgMTE6
CiNwMnBfbGlzdGVuX3JlZ19jbGFzcz04MQojcDJwX2xpc3Rlbl9jaGFubmVsPTEKI3AycF9vcGVy
X3JlZ19jbGFzcz04MQojcDJwX29wZXJfY2hhbm5lbD0xCg==
--f46d04479f7795540504ca739249--
