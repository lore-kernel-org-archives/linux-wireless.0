Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:41509 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaJWQqY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 12:46:24 -0400
Received: by mail-ob0-f179.google.com with SMTP id wp4so1047510obc.24
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2014 09:46:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1414080125.164673.182502929.61AF3AB1@webmail.messagingengine.com>
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>
	<1413510814.22769.6.camel@dcbw.local>
	<1413751717.2510219.180809145.0E693C29@webmail.messagingengine.com>
	<CANUX_P2RHVRorVABRfWVg39d4D8dj35v3fBpY3=3jvQ1U+mfEA@mail.gmail.com>
	<1413783023.2710583.180921653.10DFFCEE@webmail.messagingengine.com>
	<CANUX_P0Q7cNeBzQa=2WVZFJXPTLx8F6YQk9bGCf_3uYhc5RcGA@mail.gmail.com>
	<CANUX_P3EqgTX7cPJvQ3fWH1yijekE0G_8TiH2_OCS7nFASGtkA@mail.gmail.com>
	<1413789724.3063896.180943829.3F15F453@webmail.messagingengine.com>
	<CANUX_P1REqkSqN0dtak34OQ_pSGMtPvV3Vj61tW5wb1+n2A7mg@mail.gmail.com>
	<1413833365.2949853.181221645.22D54845@webmail.messagingengine.com>
	<CANUX_P3XzYBp7E=hScmc837TpuCr9VrxEYauG=sGMKfOCpX=qA@mail.gmail.com>
	<54461740.5000903@openwrt.org>
	<1413879792.3500640.181427549.198E9452@webmail.messagingengine.com>
	<54461AEF.7040304@openwrt.org>
	<54463CE9.3060400@gmail.com>
	<1413921415.3763081.181696749.20A0A495@webmail.messagingengine.com>
	<CANUX_P0LRRczVCSFR7RE5coaYFxwFXyqC90pdm=oVwEiEt-7zw@mail.gmail.com>
	<1414014805.4127522.182191541.14C8B4DF@webmail.messagingengine.com>
	<CANUX_P0tGagXsN6XCeb_itQehqD3O9fmqknU6iSMO432NQtATA@mail.gmail.com>
	<1414049448.32460.182326557.1A0A85A4@webmail.messagingengine.com>
	<CANUX_P3usjdccnsYPQXzKbJ1PTH91fasf6BpcsCRYZH_yq2tww@mail.gmail.com>
	<1414080125.164673.182502929.61AF3AB1@webmail.messagingengine.com>
Date: Thu, 23 Oct 2014 19:46:23 +0300
Message-ID: <CANUX_P2pJYNhLEMw=iQVe-CSbxqRDqOXL_gUZXxwpmAj2qj=FA@mail.gmail.com> (sfid-20141023_184628_334831_4BA265C0)
Subject: Re: iwlwifi: Reason 7 periodic disconnect
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?UTF-8?Q?Lauren=C8=9Biu_Nicola?= <lnicola@dend.ro>
Cc: poma <pomidorabelisima@gmail.com>, Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=e89a8f64272806cead050619ce55
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--e89a8f64272806cead050619ce55
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2014 at 7:02 PM, Lauren=C8=9Biu Nicola <lnicola@dend.ro> wr=
ote:
> Sorry, but I only saw a two-line change [1] to
> `ieee80211_rx_mgmt_beacon` (which already had a log message). Am I
> missing something?
>
> [1] http://www.spinics.net/lists/linux-wireless/msg128340.html
>

No - you are not. I did miss something...I forgot to attach the patch.
Here you go.

> Laurentiu
>
> On Thu, Oct 23, 2014, at 11:07, Emmanuel Grumbach wrote:
>> On Thu, Oct 23, 2014 at 10:30 AM, Lauren=C8=9Biu Nicola <lnicola@dend.ro=
>
>> wrote:
>> > I did; the card still gets disconnected and the message doesn't show u=
p
>> > in dmesg.
>> >
>>
>> You had *none* of the many prints I added in the log?
>>
>> That seems really weird...
>>
>> > Laurentiu
>> >
>> > On Thu, Oct 23, 2014, at 08:21, Emmanuel Grumbach wrote:
>> >> On Thu, Oct 23, 2014 at 12:53 AM, Lauren=C8=9Biu Nicola <lnicola@dend=
.ro>
>> >> wrote:
>> >> > Nope. It seems that code doesn't get executed when my issue occurs =
(or
>> >> > in my five or ten minutes of uptime). I've seen
>> >> > `ieee80211_reset_ap_probe` get called by `ieee80211_rx_mgmt_probe_r=
esp`,
>> >> > but (if I'm not wrong) not on every disconnect.
>> >> >
>> >> > And as far as I can tell, force_cam is set to true.
>> >>
>> >> Can you please try with the patch attached and send the logs?
>> >> I again need MAC80211_MLME_DEBUG.
>> >>
>> >> Thanks.
>> >>
>> >> >
>> >> > Laurentiu
>> >> >
>> >> > On Wed, Oct 22, 2014, at 12:10, Emmanuel Grumbach wrote:
>> >> >> On Tue, Oct 21, 2014 at 10:56 PM, Lauren=C8=9Biu Nicola <lnicola@d=
end.ro>
>> >> >> wrote:
>> >> >> > Yep! `scb_timeout` is 60 on my router.
>> >> >> >
>> >> >> > On Tue, Oct 21, 2014, at 14:00, poma wrote:
>> >> >> >> On 21.10.2014 10:35, Felix Fietkau wrote:
>> >> >> >> > On 2014-10-21 10:23, Lauren=C8=9Biu Nicola wrote:
>> >> >> >> >> It's an ASUS RT-N66U running NEWD-2/K3X from r24160.
>> >> >> >> > This is a Broadcom based device, so it should behave in the s=
ame way as
>> >> >> >> > other APs/Routers running the Broadcom drivers.
>> >> >> >> > The driver should only send Reason 7 when receiving a PS-Poll=
, BlockAck,
>> >> >> >> > BlockAckReq or Action frame from a station that's not associa=
ted, so
>> >> >> >> > probably it has already kicked out your iwlwifi client earlie=
r. Not sure
>> >> >> >> > why that doesn't show up in the log though.
>> >> >> >> >
>> >> >> >>
>> >> >> >> Whether this might refer to the Station Control Block Timeout v=
alue
>> >> >> >>
>> >> >> >> http://www.dd-wrt.com/wiki/index.php/Wl#scb_timeout
>> >> >> >> ...
>> >> >> >> scb_timeout
>> >> >> >>
>> >> >> >> AP only: inactivity timeout value for authenticated stas
>> >> >> >>
>> >> >>
>> >> >> Actually, mac80211 should be probing the AP every 30 seconds but a
>> >> >> beacon might abort the probe...
>> >> >> Can you try something like this:
>> >> >>
>> >> >> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>> >> >> index 75df184..c9db7cf 100644
>> >> >> --- a/net/mac80211/mlme.c
>> >> >> +++ b/net/mac80211/mlme.c
>> >> >> @@ -3295,7 +3295,8 @@ static void ieee80211_rx_mgmt_beacon(struct
>> >> >> ieee80211_sub_if_data *sdata,
>> >> >>         if (ifmgd->flags & IEEE80211_STA_CONNECTION_POLL) {
>> >> >>                 mlme_dbg_ratelimited(sdata,
>> >> >>                                      "cancelling AP probe due to a
>> >> >> received beacon\n");
>> >> >> -               ieee80211_reset_ap_probe(sdata);
>> >> >> +               pr_err("Not cancelling the probe to make sure the =
AP
>> >> >> hears us from time to time\n");
>> >> >> +               //ieee80211_reset_ap_probe(sdata);
>> >> >>         }
>> >> >>
>> >> >>         /*
>> >> >>
>> >> >>
>> >> >>
>> >> >> >>
>> >> >> >> poma
>> >> >> >>
>> >> >> >>
>> >> >> >> --
>> >> >> >> To unsubscribe from this list: send the line "unsubscribe linux=
-wireless"
>> >> >> >> in
>> >> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.h=
tml
>> >> >> --
>> >> >> To unsubscribe from this list: send the line "unsubscribe linux-wi=
reless"
>> >> >> in
>> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess"
>> >> in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless=
"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--e89a8f64272806cead050619ce55
Content-Type: application/octet-stream; name="PROBE.patch"
Content-Disposition: attachment; filename="PROBE.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1mcdkki0

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9tbG1lLmMgYi9uZXQvbWFjODAyMTEvbWxtZS5jCmlu
ZGV4IDc1ZGYxODQuLmU5YzJmMTYgMTAwNjQ0Ci0tLSBhL25ldC9tYWM4MDIxMS9tbG1lLmMKKysr
IGIvbmV0L21hYzgwMjExL21sbWUuYwpAQCAtMTI5LDYgKzEyOSw3IEBAIHZvaWQgaWVlZTgwMjEx
X3N0YV9yZXNldF9jb25uX21vbml0b3Ioc3RydWN0IGllZWU4MDIxMV9zdWJfaWZfZGF0YSAqc2Rh
dGEpCiB7CiAJc3RydWN0IGllZWU4MDIxMV9pZl9tYW5hZ2VkICppZm1nZCA9ICZzZGF0YS0+dS5t
Z2Q7CiAKKwltbG1lX2RiZyhzZGF0YSwgIiVzOiVkXG4iLCBfX2Z1bmNfXywgX19MSU5FX18pOwog
CWlmICh1bmxpa2VseSghc2RhdGEtPnUubWdkLmFzc29jaWF0ZWQpKQogCQlyZXR1cm47CiAKQEAg
LTEzNyw2ICsxMzgsNyBAQCB2b2lkIGllZWU4MDIxMV9zdGFfcmVzZXRfY29ubl9tb25pdG9yKHN0
cnVjdCBpZWVlODAyMTFfc3ViX2lmX2RhdGEgKnNkYXRhKQogCWlmIChzZGF0YS0+bG9jYWwtPmh3
LmZsYWdzICYgSUVFRTgwMjExX0hXX0NPTk5FQ1RJT05fTU9OSVRPUikKIAkJcmV0dXJuOwogCisJ
bWxtZV9kYmcoc2RhdGEsICIlczolZFxuIiwgX19mdW5jX18sIF9fTElORV9fKTsKIAltb2RfdGlt
ZXIoJnNkYXRhLT51Lm1nZC5jb25uX21vbl90aW1lciwKIAkJICByb3VuZF9qaWZmaWVzX3VwKGpp
ZmZpZXMgKyBJRUVFODAyMTFfQ09OTkVDVElPTl9JRExFX1RJTUUpKTsKIH0KQEAgLTIwODIsNiAr
MjA4NCw3IEBAIHZvaWQgaWVlZTgwMjExX3N0YV9yeF9ub3RpZnkoc3RydWN0IGllZWU4MDIxMV9z
dWJfaWZfZGF0YSAqc2RhdGEsCiAJaWYgKGlzX211bHRpY2FzdF9ldGhlcl9hZGRyKGhkci0+YWRk
cjEpKQogCQlyZXR1cm47CiAKKwltbG1lX2RiZyhzZGF0YSwgIiVzOiVkIHJlc2V0aW5nIHRoZSBD
b25uIG1vbml0b3JcbiIsIF9fZnVuY19fLCBfX0xJTkVfXyk7CiAJaWVlZTgwMjExX3N0YV9yZXNl
dF9jb25uX21vbml0b3Ioc2RhdGEpOwogfQogCkBAIC0yMDkwLDYgKzIwOTMsOCBAQCBzdGF0aWMg
dm9pZCBpZWVlODAyMTFfcmVzZXRfYXBfcHJvYmUoc3RydWN0IGllZWU4MDIxMV9zdWJfaWZfZGF0
YSAqc2RhdGEpCiAJc3RydWN0IGllZWU4MDIxMV9pZl9tYW5hZ2VkICppZm1nZCA9ICZzZGF0YS0+
dS5tZ2Q7CiAJc3RydWN0IGllZWU4MDIxMV9sb2NhbCAqbG9jYWwgPSBzZGF0YS0+bG9jYWw7CiAK
KwltbG1lX2RiZyhzZGF0YSwgIiVzOiVkIHN0YXJ0XG4iLCBfX2Z1bmNfXywgX19MSU5FX18pOwor
CiAJbXV0ZXhfbG9jaygmbG9jYWwtPm10eCk7CiAJaWYgKCEoaWZtZ2QtPmZsYWdzICYgSUVFRTgw
MjExX1NUQV9DT05ORUNUSU9OX1BPTEwpKQogCQlnb3RvIG91dDsKQEAgLTIxMTAsNiArMjExNSw3
IEBAIHN0YXRpYyB2b2lkIGllZWU4MDIxMV9yZXNldF9hcF9wcm9iZShzdHJ1Y3QgaWVlZTgwMjEx
X3N1Yl9pZl9kYXRhICpzZGF0YSkKIAkgKi8KIAlpZWVlODAyMTFfc3RhX3Jlc2V0X2JlYWNvbl9t
b25pdG9yKHNkYXRhKTsKIAorCW1sbWVfZGJnKHNkYXRhLCAiJXM6JWQgcG9zdHBvbmluZyB0aGUg
Q29ubl9tb25fdGltZXJcbiIsIF9fZnVuY19fLCBfX0xJTkVfXyk7CiAJbW9kX3RpbWVyKCZpZm1n
ZC0+Y29ubl9tb25fdGltZXIsCiAJCSAgcm91bmRfamlmZmllc191cChqaWZmaWVzICsKIAkJCQkg
ICBJRUVFODAyMTFfQ09OTkVDVElPTl9JRExFX1RJTUUpKTsKQEAgLTIxNjIsMTYgKzIxNjgsMjAg
QEAgdm9pZCBpZWVlODAyMTFfc3RhX3R4X25vdGlmeShzdHJ1Y3QgaWVlZTgwMjExX3N1Yl9pZl9k
YXRhICpzZGF0YSwKIAogCWlmIChpZWVlODAyMTFfaXNfbnVsbGZ1bmMoaGRyLT5mcmFtZV9jb250
cm9sKSAmJgogCSAgICBzZGF0YS0+dS5tZ2QucHJvYmVfc2VuZF9jb3VudCA+IDApIHsKLQkJaWYg
KGFjaykKKwkJaWYgKGFjaykgeworCQkJbWxtZV9kYmcoc2RhdGEsICIlczolZCBSZXNldGluZyBj
b25uIG1vblxuIiwgX19mdW5jX18sIF9fTElORV9fKTsKIAkJCWllZWU4MDIxMV9zdGFfcmVzZXRf
Y29ubl9tb25pdG9yKHNkYXRhKTsKKwkJfQogCQllbHNlCiAJCQlzZGF0YS0+dS5tZ2QubnVsbGZ1
bmNfZmFpbGVkID0gdHJ1ZTsKIAkJaWVlZTgwMjExX3F1ZXVlX3dvcmsoJnNkYXRhLT5sb2NhbC0+
aHcsICZzZGF0YS0+d29yayk7CiAJCXJldHVybjsKIAl9CiAKLQlpZiAoYWNrKQorCWlmIChhY2sp
IHsKKwkJbWxtZV9kYmcoc2RhdGEsICIlczolZCBSZXNldGluZyBjb25uIG1vblxuIiwgX19mdW5j
X18sIF9fTElORV9fKTsKIAkJaWVlZTgwMjExX3N0YV9yZXNldF9jb25uX21vbml0b3Ioc2RhdGEp
OworCX0KIH0KIAogc3RhdGljIHZvaWQgaWVlZTgwMjExX21nZF9wcm9iZV9hcF9zZW5kKHN0cnVj
dCBpZWVlODAyMTFfc3ViX2lmX2RhdGEgKnNkYXRhKQo=
--e89a8f64272806cead050619ce55--
