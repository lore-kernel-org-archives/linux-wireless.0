Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:57565 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZBMLre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 06:47:34 -0500
Received: by qyk4 with SMTP id 4so1547955qyk.13
        for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 03:47:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890902130023w3c192b04r3a41b4643eedb530@mail.gmail.com>
References: <1925ef8a0902130015o6df0c962n3fe05ec420d0aef@mail.gmail.com>
	 <43e72e890902130023w3c192b04r3a41b4643eedb530@mail.gmail.com>
Date: Fri, 13 Feb 2009 14:47:31 +0300
Message-ID: <1925ef8a0902130347i32905e04g439ed04d6c718594@mail.gmail.com> (sfid-20090213_124738_238461_6CB98FF5)
Subject: Re: compat-wireless with CONFIG_MAC80211disabled
From: Vitja Makarov <vitja.makarov@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015175cdf54f4cba40462cb6681
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0015175cdf54f4cba40462cb6681
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

2009/2/13 Luis R. Rodriguez <mcgrof@gmail.com>:
> On Fri, Feb 13, 2009 at 12:15 AM, Vitja Makarov <vitja.makarov@gmail.com> wrote:
>> Hi!
>>
>> I was trying to build compat wireless for my arm board.
>> First of all I disabled CONFIG_MAC80211 in my kernel, and successfully
>> built compat-wireless.
>>
>> Then at runtime I get kernel panic.
>> Then I found that sk_buff in 2.6.28 depends on CONFIG_MAC80211, so
>> enabling it solves my problem.
>
> Ah nice catch. Well you're the first to try that and report it.
>
>> Shouldn't compat-wireless Makefile check kernel dot config for this
>> option as well as for wireless extension?
>
> Yes, Can you send a patch, put some nasty warn on config.mk if its not
> enabled on 2.6.28 and error out.
>
>  Luis
>

Here is patch, sorry for attachment, firewall here blocks all email
related ports.

vitja.

--0015175cdf54f4cba40462cb6681
Content-Type: text/x-diff; charset=US-ASCII; name="error-on-mac80211-disabled.diff"
Content-Disposition: attachment; filename="error-on-mac80211-disabled.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fr4snl910

ZGlmZiAtLWdpdCBhL2NvbmZpZy5tayBiL2NvbmZpZy5tawppbmRleCA0OWU4MmIzLi5mOTFmOGYx
IDEwMDY0NAotLS0gYS9jb25maWcubWsKKysrIGIvY29uZmlnLm1rCkBAIC0xNiw4ICsxNiw2IEBA
IGVuZGlmCiBpZmVxICgkKENPTkZJR19NQUM4MDIxMSkseSkKICQoZXJyb3IgIkVSUk9SOiB5b3Ug
aGF2ZSBNQUM4MDIxMSBjb21waWxlZCBpbnRvIHRoZSBrZXJuZWwsIENPTkZJR19NQUM4MDIxMT15
LCBhcyBzdWNoIHlvdSBjYW5ub3QgcmVwbGFjZSBpdHMgbWFjODAyMTEgZHJpdmVyLiBZb3UgbmVl
ZCB0aGlzIHNldCB0byBDT05GSUdfTUFDODAyMTE9bS4gSWYgeW91IGFyZSB1c2luZyBGZWRvcmEg
dXBncmFkZSB5b3VyIGtlcm5lbCBhcyBsYXRlciB2ZXJzaW9uIHNob3VsZCB0aGlzIHNldCBhcyBt
b2R1bGFyLiBGb3IgZnVydGhlciBpbmZvcm1hdGlvbiBvbiBGZWRvcmEgc2VlIGh0dHBzOi8vYnVn
emlsbGEucmVkaGF0LmNvbS9zaG93X2J1Zy5jZ2k/aWQ9NDcwMTQzLiBJZiB5b3UgYXJlIHVzaW5n
IHlvdXIgb3duIGtlcm5lbCByZWNvbXBpbGUgaXQgYW5kIG1ha2UgbWFjODAyMTEgbW9kdWxhciIp
CiBlbmRpZgotIyBXaXJlbGVzcyBzdWJzeXN0ZW0gc3R1ZmYKLUNPTkZJR19NQUM4MDIxMT1tCiAK
ICMgV2Ugd2lsbCB3YXJuIHdoZW4geW91IGRvbid0IGhhdmUgTVEgc3VwcG9ydCBvciBORVRfU0NI
RUQgZW5hYmxlZC4KICMKQEAgLTQ0LDYgKzQyLDEyIEBAICQoZXJyb3IgIkVSUk9SOiBZb3VyIDIu
Ni4yNyBrZXJuZWwgaGFzIENPTkZJR19EWU5BTUlDX0ZUUkFDRSwgcGxlYXNlIHVwZ3JhZGUgeW91
CiBlbmRpZgogZW5kaWYKIAoraWZlcSAoJChzaGVsbCB0ZXN0ICQoS0VSTkVMX1NVQkxFVkVMKSAt
Z2UgMjggJiYgZWNobyB5ZXMpLHllcykKK2lmZXEgKCQoQ09ORklHX01BQzgwMjExKSwpCiskKGVy
cm9yICJFUlJPUjogWW91ciA+PTIuNi4yOCBrZXJuZWwgaGFzIENPTkZJR19NQUM4MDIxMSBkaXNh
YmxlZCwgeW91IHNob3VsZCBoYXZlIGl0IENPTkZJR19NQUM4MDIxMT1tIGlmIHlvdSB3YW50IHRv
IHVzZSB0aGlzIHRoaW5nLiIpCitlbmRpZgorZW5kaWYKKwogaWZuZXEgKCQoS0VSTkVMUkVMRUFT
RSksKSAjIFRoaXMgcHJldmVudHMgYSB3YXJuaW5nCiAKIGlmZXEgKCQoQ09ORklHX05FVF9TQ0hF
RCksKQpAQCAtNTksNiArNjMsOCBAQCBlbmRpZgogZW5kaWYgIyBidWlsZCBjaGVjawogZW5kaWYg
IyBrZXJuZWwgTWFrZWZpbGUgY2hlY2sKIAorIyBXaXJlbGVzcyBzdWJzeXN0ZW0gc3R1ZmYKK0NP
TkZJR19NQUM4MDIxMT1tCiAKICMgY2hvb3NlIGJldHdlZW4gcGlkIGFuZCBtaW5zdHJlbCBhcyBk
ZWZhdWx0IHJhdGUgY29udHJvbCBhbGdvcml0aG0KIENPTkZJR19NQUM4MDIxMV9SQ19ERUZBVUxU
PW1pbnN0cmVsCg==
--0015175cdf54f4cba40462cb6681--
