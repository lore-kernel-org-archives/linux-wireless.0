Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59054 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612Ab1EYMTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2011 08:19:07 -0400
Received: by qyk7 with SMTP id 7so2057760qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 May 2011 05:19:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikcEsKYo=c=ZmzJRbmfgjmrFmx9bg@mail.gmail.com>
References: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com>
	<201105241627.49201.helmut.schaa@googlemail.com>
	<BANLkTikcEsKYo=c=ZmzJRbmfgjmrFmx9bg@mail.gmail.com>
Date: Wed, 25 May 2011 14:19:06 +0200
Message-ID: <BANLkTin4MvdbqugTjtXvmjz5N8_TyTY7OA@mail.gmail.com> (sfid-20110525_141912_041847_19590BC6)
Subject: Re: Initial automatic channel selection implementation
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	hostap@lists.shmoo.com, Matt Smith <Matt.Smith@atheros.com>
Content-Type: multipart/mixed; boundary=00163641728109145204a418b626
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--00163641728109145204a418b626
Content-Type: text/plain; charset=ISO-8859-1

On Wed, May 25, 2011 at 12:54 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> Yes, thanks this is a lot of work already done. Now we just need a
> basic algorithm to parse this, quantify how ideal this channel is and
> then spit out a desired optimal channel.

That's what I've hacked some time ago (in form of the attached _ugly_ shell
script that does auto channel selection with rt2x00, not sure if it works
correct with other drivers as the survey dump differs somehow between
rt2x00, ath5k and ath9k, and it only does channel 1-11):

- Iterate over all channels and stay on each channel for some time
- Store busy time stats for each channel
- Choose the channel with the lowest busy time (and on 2.4Ghz also
  check the busy times on adjacent channels)

Btw. is the idea to get the auto channel selection into hostapd/supplicant
or in a new userspace tool?

Helmut

--00163641728109145204a418b626
Content-Type: application/x-sh; name="auto_channel.sh"
Content-Disposition: attachment; filename="auto_channel.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_go48k8ux0

IyEvYmluL3NoCgppdyBwaHkgcGh5MCBpbnRlcmZhY2UgYWRkIG1vbjAgdHlwZSBtb25pdG9yCmlm
Y29uZmlnIG1vbjAgdXAKaXcgZGV2IG1vbjAgc3VydmV5IGR1bXAgPiAvZGV2L251bGwKCiMgY29s
bGVjdCBidXN5IHRpbWUgc3RhdGlzdGljcyBmb3IgZWFjaCAyLDRHaHogY2hhbm5lbApmb3IgaSBp
biBgc2VxIDEgMTFgCmRvCgkjIGxldCdzIHN0YXkgb24gZWFjaCBjaGFubmVsIGZvciB+MjAwbXMK
CWl3IGRldiBtb24wIHNldCBjaGFubmVsICRpCglzbGVlcCAwLjIKCgkjIGV4dHJhY3QgYnVzeS9h
Y3RpdmUgdGltZSByYXRpbwoJZHVtcD1gaXcgZGV2IG1vbjAgc3VydmV5IGR1bXBgCgl0aW1lPWBl
Y2hvICRkdW1wIHwgZ3JlcCAtbyAtZSAiY2hhbm5lbCBhY3RpdmUgdGltZTogWzAtOV0qIG1zIiB8
IGdyZXAgLW8gLWUgIlswLTldKiIgfCBoZWFkIC1uMWAKCWJ1c3k9YGVjaG8gJGR1bXAgfCBncmVw
IC1vIC1lICJjaGFubmVsIGJ1c3kgdGltZTogWzAtOV0qIG1zIiB8IGdyZXAgLW8gLWUgIlswLTld
KiIgfCBoZWFkIC1uMWAKCgkjIGNhbGN1bGF0ZSBidXN5dGltZSBwZXJjZW50YWdlIHZhbHVlCglw
ZXJjZW50PWBleHByICRidXN5ICIqIiAxMDAgIi8iICR0aW1lYAoJZXZhbCBwZXJjZW50JGk9JHBl
cmNlbnQKCgllY2hvICJDaGFubmVsICRpIGJ1c3kgdGltZSAke2J1c3l9LyR7dGltZX1tcywgJHtw
ZXJjZW50fSUiCmRvbmUKCiMgbm93IGFkZCBvdmVybGFwcGluZyBjaGFubmVsIGJ1c3kgdGltZXMs
IGhlbmNlIHRoZSBtYXhpbXVtIGJ1c3kgdGltZSBpcyA1MDAKbWluX2J1c3l0aW1lPTUwMApjaGFu
bmVsPTEKCmZvciBpIGluIGBzZXEgMSAxMWAKZG8KCSMgZWFjaCBjaGFubmVsIGlzIGluZmx1ZW5j
ZWQgYnkgb3ZlcmxhcHBpbmcgY2hhbm5lbHMgKy0yCglzdGFydF9jaGFubmVsPWBleHByICRpIC0g
MmAKCXN0b3BfY2hhbm5lbD1gZXhwciAkaSArIDJgCgoJZXhwciAiJHN0YXJ0X2NoYW5uZWwiICI8
IiAxID4gL2Rldi9udWxsICYmIHN0YXJ0X2NoYW5uZWw9MQoJZXhwciAiJHN0b3BfY2hhbm5lbCIg
Ij4iIDExID4gL2Rldi9udWxsICYmIHN0b3BfY2hhbm5lbD0xMQoKCSMgYWRkIGJ1c3l0aW1lIHZh
bHVlcyBvZiBhbGwgb3ZlcmxhcHBpbmcgY2hhbm5lbHMKCWJ1c3l0aW1lPTAKCWZvciBqIGluIGBz
ZXEgJHN0YXJ0X2NoYW5uZWwgJHN0b3BfY2hhbm5lbGAKCWRvCgkJZXZhbCB0bXA9XCRwZXJjZW50
JGoKCQlidXN5dGltZT1gZXhwciAkYnVzeXRpbWUgKyAkdG1wYAoJZG9uZQoKCWV4cHIgJGJ1c3l0
aW1lICI8IiAkbWluX2J1c3l0aW1lID4gL2Rldi9udWxsICYmIG1pbl9idXN5dGltZT0iJGJ1c3l0
aW1lIiAmJiBjaGFubmVsPSIkaSIKZG9uZQoKZWNobyAiU2VsZWN0IGNoYW5uZWwgJGNoYW5uZWwi
Cml3IGRldiBtb24wIGRlbAoK
--00163641728109145204a418b626--
