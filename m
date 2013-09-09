Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:41986 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab3IIXE4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 19:04:56 -0400
Received: by mail-ob0-f170.google.com with SMTP id eh20so6598510obb.29
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 16:04:55 -0700 (PDT)
Message-ID: <522E5416.4010901@lwfinger.net> (sfid-20130910_010459_971143_E7E48B5F)
Date: Mon, 09 Sep 2013 18:04:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
CC: Timothy Rundle <tgrundlesr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8192CU continually reconnecting
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net> <522DE8CA.9010008@ilande.co.uk> <522DFF83.6000605@lwfinger.net> <522E0573.4000804@ilande.co.uk> <522E1B7D.5010107@lwfinger.net> <522E463E.4040701@ilande.co.uk>
In-Reply-To: <522E463E.4040701@ilande.co.uk>
Content-Type: multipart/mixed;
 boundary="------------000108000907060209040701"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000108000907060209040701
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/09/2013 05:05 PM, Mark Cave-Ayland wrote:
> On 09/09/13 20:03, Larry Finger wrote:
>
>> There were no secrets in that dump, but it did reveal a major clue.
>>
>> A response from your system for your AP was:
>>
>> mode 2, state 0, is_beacon 0, is_probe_resp 1, length 147
>>
>> For the number of beacons to be updated, the state has to be 2 or 3. My
>> system has scan_ssid=1 in the wpa_supplicant configuration file. When
>> the scan finishes, then a value of 2 is set into the mode variable.
>>
>> The attached updated patch should set the correct mode even if scanning
>> is not enabled.
>
> Aha! This patch is definitely a step in the right direction - with this applied,
> wpa_supplicant now associates immediately with the AP without the initial delay :)
>
> However... I'm still seeing the same "rtlwifi:rtl_watchdog_wq_callback():<0-0>
> AP off, try to reconnect now" message appearing in dmesg after every 10s or so.
> I've uploaded the updated dmesg output to
> http://www.ilande.co.uk/tmp/rtl8192cu_patch-2-dmesg.txt for you to take a look at.
>
> I also tried another experiment which was to change your patch so that instead
> of logging just the first 100 beacons to dmesg, log every 10th beacon (count %
> 10) to dmesg instead. This showed that even when the timeouts are occurring
> against the AP, I'm still seeing a continual stream of beacons from other
> stations on the network.

Looking at only every 10th one could be systematically missing the ones from 
your AP.

> This makes me wonder if Oleksij is correct in that the problem is that not all
> the frames coming from the USB interface are being picked up by the driver.
> Perhaps not all incoming USB RX buffers are being scanned (causing some queued
> frames to be lost) or maybe USB transfers can contain more than 1 frame and
> rtlwifi is only catching the first frame within each notified transfer?

None of those suppositions make any sense.

> To double check whether it was a general ehci-pci problem, I tried plugging in a
> spare zd1211rw dongle and that worked absolutely fine. So I think that's a
> reasonable indication that general USB function is okay.

I do not suspect any USB problem unless it is in rtl8192cu.

Could you please run the attached patch? It will only print messages for your 
AP, and print enough to still be getting them when the AP timeout occurs.

Thanks,

Larry


--------------000108000907060209040701
Content-Type: text/plain; charset=UTF-8;
 name="rtl8192cu_dump_AP_off"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rtl8192cu_dump_AP_off"

SW5kZXg6IHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3
aWZpL3VzYi5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS5vcmln
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvdXNiLmMKKysrIHdpcmVsZXNzLXRlc3Rp
bmctc2F2ZS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3VzYi5jCkBAIC00ODQsNiAr
NDg0LDggQEAgc3RhdGljIHZvaWQgX3J0bF91c2JfcnhfcHJvY2Vzc19hZ2coc3RydQogCQkJ
aWYgKHVuaWNhc3QpCiAJCQkJcnRscHJpdi0+bGlua19pbmZvLm51bV9yeF9pbnBlcmlvZCsr
OwogCQl9CisJCS8qIHN0YXRpYyBiY24gZm9yIHJvYW1pbmcgKi8KKwkJcnRsX2JlYWNvbl9z
dGF0aXN0aWMoaHcsIHNrYik7CiAJfQogfQogCkluZGV4OiB3aXJlbGVzcy10ZXN0aW5nLXNh
dmUvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9jb3JlLmMKPT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQot
LS0gd2lyZWxlc3MtdGVzdGluZy1zYXZlLm9yaWcvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRs
d2lmaS9jb3JlLmMKKysrIHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS9kcml2ZXJzL25ldC93aXJl
bGVzcy9ydGx3aWZpL2NvcmUuYwpAQCAtMTg0LDYgKzE4NCw3IEBAIHN0YXRpYyBpbnQgcnRs
X29wX2FkZF9pbnRlcmZhY2Uoc3RydWN0IGkKIAkJCQkJcnRscHJpdi0+Y2ZnLT5tYXBzCiAJ
CQkJCVtSVExfSUJTU19JTlRfTUFTS1NdKTsKIAkJfQorCQltYWMtPmxpbmtfc3RhdGUgPSBN
QUM4MDIxMV9MSU5LRUQ7CiAJCWJyZWFrOwogCWNhc2UgTkw4MDIxMV9JRlRZUEVfQURIT0M6
CiAJCVJUX1RSQUNFKHJ0bHByaXYsIENPTVBfTUFDODAyMTEsIERCR19MT1VELApJbmRleDog
d2lyZWxlc3MtdGVzdGluZy1zYXZlL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvYmFz
ZS5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0KLS0tIHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS5vcmlnL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvYmFzZS5jCisrKyB3aXJlbGVzcy10ZXN0aW5nLXNh
dmUvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9iYXNlLmMKQEAgLTEyODcsNiArMTI4
NywxNyBAQCB2b2lkIHJ0bF9iZWFjb25fc3RhdGlzdGljKHN0cnVjdCBpZWVlODAyCiB7CiAJ
c3RydWN0IHJ0bF9wcml2ICpydGxwcml2ID0gcnRsX3ByaXYoaHcpOwogCXN0cnVjdCBpZWVl
ODAyMTFfaGRyICpoZHIgPSAoc3RydWN0IGllZWU4MDIxMV9oZHIgKilza2ItPmRhdGE7CisJ
c3RhdGljIGludCBjb3VudDsKKworCS8qIGFuZCBvbmx5IGJlYWNvbnMgZnJvbSB0aGUgYXNz
b2NpYXRlZCBCU1NJRCwgcGxlYXNlICovCisJaWYgKGNvbXBhcmVfZXRoZXJfYWRkcihoZHIt
PmFkZHIzLCBydGxwcml2LT5tYWM4MDIxMS5ic3NpZCkpCisJCXJldHVybjsKKworCWlmIChj
b3VudCsrIDwgMTIwMCkgeworCQlwcl9pbmZvKCJtb2RlICVkLCBzdGF0ZSAlZCwgaXNfYmVh
Y29uICVkLCBpc19wcm9iZV9yZXNwICVkLCBsZW5ndGggJWRcbiIsCisJCQlydGxwcml2LT5t
YWM4MDIxMS5vcG1vZGUsIHJ0bHByaXYtPm1hYzgwMjExLmxpbmtfc3RhdGUsIGllZWU4MDIx
MV9pc19iZWFjb24oaGRyLT5mcmFtZV9jb250cm9sKSwKKwkJCWllZWU4MDIxMV9pc19wcm9i
ZV9yZXNwKGhkci0+ZnJhbWVfY29udHJvbCksIHNrYi0+bGVuKTsKKwl9CiAKIAlpZiAocnRs
cHJpdi0+bWFjODAyMTEub3Btb2RlICE9IE5MODAyMTFfSUZUWVBFX1NUQVRJT04pCiAJCXJl
dHVybjsKQEAgLTEzMDMsMTAgKzEzMTQsNiBAQCB2b2lkIHJ0bF9iZWFjb25fc3RhdGlzdGlj
KHN0cnVjdCBpZWVlODAyCiAJaWYgKHNrYi0+bGVuIDw9IDQwICsgRkNTX0xFTikKIAkJcmV0
dXJuOwogCi0JLyogYW5kIG9ubHkgYmVhY29ucyBmcm9tIHRoZSBhc3NvY2lhdGVkIEJTU0lE
LCBwbGVhc2UgKi8KLQlpZiAoY29tcGFyZV9ldGhlcl9hZGRyKGhkci0+YWRkcjMsIHJ0bHBy
aXYtPm1hYzgwMjExLmJzc2lkKSkKLQkJcmV0dXJuOwotCiAJcnRscHJpdi0+bGlua19pbmZv
LmJjbl9yeF9pbnBlcmlvZCsrOwogfQogRVhQT1JUX1NZTUJPTF9HUEwocnRsX2JlYWNvbl9z
dGF0aXN0aWMpOwo=
--------------000108000907060209040701--
