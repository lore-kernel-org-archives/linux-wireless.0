Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44480 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757825Ab0LBRdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 12:33:52 -0500
Received: by qwb7 with SMTP id 7so8611491qwb.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 09:33:51 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <201012011921.11151.br1@einfach.org>
References: <AANLkTi=_F0orXPY79ojoPKEqn4ohQjV5Rj5Qb3H7CR8f@mail.gmail.com>
	<201012011921.11151.br1@einfach.org>
Date: Thu, 2 Dec 2010 18:33:48 +0100
Message-ID: <AANLkTimcV+pHp8ui-hExnsBfuQ2PtGA2aZidCYSFsQnh@mail.gmail.com>
Subject: Re: [linux-next] next-20101201: ath5k permanently disconnecting
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Bruno Randolf <br1@einfach.org>,
	Nick Kossifidis <mickflemm@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: multipart/mixed; boundary=0016362843d61cd5fb049670d3ac
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0016362843d61cd5fb049670d3ac
Content-Type: text/plain; charset=UTF-8

On Wed, Dec 1, 2010 at 11:21 AM, Bruno Randolf <br1@einfach.org> wrote:
> On Wed December 1 2010 19:09:03 Sedat Dilek wrote:
>> Hi,
>>
>> I have built today a linux-next (next-20101201) kernel which includes
>> wireless-next-2.6 up to master-2010-11-30.
[...]
>> Unfortunately, my wlan network connection is totally unstable.
[...]
> 1.) For identification of the chipset, please:
> dmesg |grep "ath5.*chip"
>
> 2.) Is there a problem when you don't use encryption?
>
> 3.) git bisect might help track it down.
>
> bruno

OK, I did not a "classic" git-bisect, I created from linux-next
(next-20101202) GIT tree a revert-ath5k patchset (30 in total).

[1] VERY GOOD: Revertiing all 30 patches

...leads to a stable system.

[2] REDUCED DISCONNECTIONS DROPS: Reverting 0001..0008

This stabilizes the system, but... listening to a radio
broadcast-stream with VLC is a pain in the ass... permanent audio
dropouts. I had only 2 disconnections in the first 10mins when system
was up (normally I can see disconnects after loggin into my KDE
desktop).

[3] GOOD AUDIO STREAMING: Reverting 0001..0014

This is just fine, system like I am used to.

[4] CONCLUSION

So I played a bit with my revert-patchset.

Reverting 0001..0008 + a refreshed v2 of
0014-Revert-ath5k-Use-turbo-flag-on-DCU.patch (patch attached) is
doing the job here.

Having a closer look into 0008 (parts of
drivers/net/wireless/ath/ath5k/reset.c):

$ grep AR5212 patches/revert-wireless-patches/0008-Revert-ath5k-Support-synth-only-channel-change-for-A.patch
-       if (ah->ah_version == AR5K_AR5212)
+                        * On AR5212 TSF is almost preserved across a
-                * On AR5212 TSF is almost preserved across a
+               if (ah->ah_version == AR5K_AR5212) {
-       if (ah->ah_version == AR5K_AR5212 &&

As I mentionned I have a AR5212 wlan device!
What to do with that parts?
Any idea?

Kind Regards,
- Sedat -

P.S.: I have added a list containing all commit-ids (chronological)
and a script how I reverted (documenting for myself).

$ ls patches/revert-wireless-patches/00*.patch
patches/revert-wireless-patches/0001-Revert-ath5k-Set-turbo-bit-on-rf-bank-2.patch
patches/revert-wireless-patches/0002-Revert-ath5k-Clean-up-turbo-mode-initvals-rfregs.patch
patches/revert-wireless-patches/0003-Revert-ath5k-Cleanup-turbo-channel-flags.patch
patches/revert-wireless-patches/0004-Revert-ath5k-Use-correct-clock-when-setting-ofdm-tim.patch
patches/revert-wireless-patches/0005-Revert-ath5k-Skip-tx-power-setting-on-AR5210-for-now.patch
patches/revert-wireless-patches/0006-Revert-ath5k-Tweak-phy-activate-to-rx-start-delay-ba.patch
patches/revert-wireless-patches/0007-Revert-ath5k-No-need-to-save-restore-staid-flags-on-.patch
patches/revert-wireless-patches/0008-Revert-ath5k-Support-synth-only-channel-change-for-A.patch
patches/revert-wireless-patches/0009-Revert-ath5k-Skip-powertable-setting-when-we-are-on-.patch
patches/revert-wireless-patches/0010-Revert-ath5k-Update-PLL-programming-for-turbo-half-q.patch
patches/revert-wireless-patches/0011-Revert-ath5k-Update-spur-mitigation-filter-for-turbo.patch
patches/revert-wireless-patches/0012-Revert-ath5k-Tweak-power-detector-delays-on-RF5111-R.patch
patches/revert-wireless-patches/0013-Revert-ath5k-Always-set-IFS-intervals-on-reset.patch
patches/revert-wireless-patches/0014-Revert-ath5k-Use-turbo-flag-on-DCU.patch
patches/revert-wireless-patches/0015-Revert-ath5k-Set-all-IFS-intervals-not-just-slot-tim.patch
patches/revert-wireless-patches/0016-Revert-ath5k-Extend-rate_duration.patch
patches/revert-wireless-patches/0017-Revert-ath5k-Extend-get_default_sifs-slot_time.patch
patches/revert-wireless-patches/0018-Revert-ath5k-Move-tx-retries-setting-outside-reset_t.patch
patches/revert-wireless-patches/0019-Revert-ath5k-Increase-PHY-settling-parameters-for-tu.patch
patches/revert-wireless-patches/0020-Revert-ath5k-Small-cleanup-on-tweak_initvals.patch
patches/revert-wireless-patches/0021-Revert-ath5k-Put-core-clock-initialization-on-a-new-.patch
patches/revert-wireless-patches/0022-Revert-ath5k-Add-new-field-on-ath5k_hw-to-track-band.patch
patches/revert-wireless-patches/0023-Revert-ath5k-Use-new-function-to-stop-beacon-queue.patch
patches/revert-wireless-patches/0024-Revert-ath5k-Check-RXE-when-setting-RXDP.patch
patches/revert-wireless-patches/0025-Revert-ath5k-Use-DCU-early-termination-correctly.patch
patches/revert-wireless-patches/0026-Revert-ath5k-Debug-DMA-timeouts.patch
patches/revert-wireless-patches/0027-Revert-ath5k-Use-new-dma_stop-function-on-base.c.patch
patches/revert-wireless-patches/0028-Revert-ath5k-Stop-PCU-on-reset.patch
patches/revert-wireless-patches/0029-Revert-ath5k-Add-new-function-to-stop-rx-tx-DMA.patch
patches/revert-wireless-patches/0030-Revert-ath5k-Reset-cleanup-and-generic-cleanup.patch

--0016362843d61cd5fb049670d3ac
Content-Type: text/x-diff; charset=US-ASCII;
	name="0014-Revert-ath5k-Use-turbo-flag-on-DCU-v2.patch"
Content-Disposition: attachment;
	filename="0014-Revert-ath5k-Use-turbo-flag-on-DCU-v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gh7wwccg0

SW5kZXg6IGxpbnV4LW5leHQvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDVrL3FjdS5jCj09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0KLS0tIGxpbnV4LW5leHQub3JpZy9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRo
NWsvcWN1LmMKKysrIGxpbnV4LW5leHQvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDVrL3Fj
dS5jCkBAIC02NDcsMTEgKzY0Nyw2IEBACiAJCSAqIG9uIGF0aDVrX2h3X3NldF9pZnNfaW50ZXJ2
YWxzICovCiAJCWF0aDVrX2h3X3NldF90eF9yZXRyeV9saW1pdHMoYWgsIDApOwogCi0JLyogU2V0
IHRoZSB0dXJibyBmbGFnIHdoZW4gb3BlcmF0aW5nIG9uIDQwTUh6ICovCi0JaWYgKGFoLT5haF9i
d21vZGUgPT0gQVI1S19CV01PREVfNDBNSFopCi0JCUFSNUtfUkVHX0VOQUJMRV9CSVRTKGFoLCBB
UjVLX0RDVV9HQkxfSUZTX01JU0MsCi0JCQkJQVI1S19EQ1VfR0JMX0lGU19NSVNDX1RVUkJPX01P
REUpOwotCiAJLyogSWYgd2UgZGlkbid0IHNldCBJRlMgdGltaW5ncyB0aHJvdWdoCiAJICogYXRo
NWtfaHdfc2V0X2NvdmVyYWdlX2NsYXNzIG1ha2Ugc3VyZQogCSAqIHdlIHNldCB0aGVtIGhlcmUg
Ki8K
--0016362843d61cd5fb049670d3ac
Content-Type: application/octet-stream; name="revert_ath5k_patches.list"
Content-Disposition: attachment; filename="revert_ath5k_patches.list"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gh7x4ynt1

NDM1MmZhYjVjMmExYTYwMjQ0N2Q3MTFjODRkMTQ5YmYyZjBiYzdiYQo4YzJiNDE4YTA3YjRkYzc3
ZDdlZmFkYjg5MGJhOWFkMWE0MTYxYzNmCmFjYjA5MWQ2N2M1Yzk2NDljZjVkMjUwNTVlZjZmZDY0
MjM5YTY3NjIKNzNhMDZhNjgzNDU1ZjQ3MmNjMDlhZDI0OTA2NGM2NmE0MWUyOWUzOQozYmIxNzY1
NDYwNTk2NTIyNmU1YjMyMmRiYzIyZWNlNWZmMzU0YWM1CmIwMmY1ZDFhMTdjNjUyYTc0MDk4ZjJh
MDRkYjdmYjhlNjIyMDA1N2UKYzJiMGViZWYyNjJlMGE5YjY0ZjdlYThlYzgzN2NmYzI5NjA1YmVm
Nwo4YWVjN2FmOTliMWU0NTk0YzRiYjllMWM0ODAwNWU2MTExZjk3ZThlCjRjNTc1ODFkOTM5ZmQw
ZjhmMjQ0Yjk3MzA4MTIwNjlmNGRhYzMwOGEKZjA4ZmJmNmNmNGEzMWM4ZGY1MmIyMTQ0MGM3YTdl
NmZiZTQ3NGIyOAphMjY3N2ZlNDI5OGM2MWYwZTkzYzA2M2U1OTgxNWJmMjFjNTMwYzRhCmIyYjRj
NjlmNjgyYTI4Njg0MTE4OTlhNzc4NDIwNjFkZDc0NTg4NGYKNzFiYTFjMzA4NTE1NzViNDNiYTc2
YjBmOWMyNmZmNTU2N2U4MTM2Ywo0NzNjYWUyNzYyMGMyNzM3N2UyNzhhNmY5MmFhYTQ4MzA2MGUz
YzE5CmVlYjg4MzJiMzE4MWQ2Y2E4NTkzMDUxYjY4YzQ2NmU1ZDI2NTNiYjMKNjFjZGUwMzcyMzRj
NGI4ZTY0OTdhMjNmNWYyMzZjNjRjYmY5ZDQxZAozMDE3ZmNhYjQxNmQ4ZDFlZTQ4Y2ExNmFhOWEz
MDYyZjYwMGRhYjhlCjI1ZGRmYTE5NTczNTkzNDI1NmZkYTU1YmI0ZjJkNzQ5YzE5Mzg2ZmYKYjQw
NTA4NmJhNDc2NzhhNWI4ZjZlN2NkODM1YTNkMjdlYmI2Zjc0NAozMjUwODlhYjU4NDdmNWMxZTQz
ZjQyYmI5MGQzMmY5ODE4NjdjNGMxCmMyOTc1NjAyMDZhZGYwY2RhOGNlMzhlZjliMjBiMGEwMjU3
NTRjNGQKZmEzZDJmZWVmZjQ3MjNjY2U4ZDQ3MjI5MDI0OTJkNjBiN2Y3NWZjYwoxNGZhZTJkNGI2
MWI4OTBjZWE1OGQ2MzA5MTQwNmI4NmVjOWJhZmNkCmU4MzI1ZWQ4NzQ1N2UwN2I5Y2VlYjFlN2Ez
MWRmNzg3ZGQ3ZWUxMDYKZjczMTdiYTJkNjY5YzFiNTRmYjMxZWQ3ODM0MzYxYTcwMGE3OTIxNwpi
M2EyOGU2OGQ1YzhkNzg4YTRlNTM4YTExOWE1ZDMyNjU0NWFkZDhhCjgwZGFjOWVlY2JkYjk1ZjYx
YjliM2M3MDgxZTAyNDEyMTU1OTgyYjcKZTA4OGYyM2JlMTY2NjM1YjM5Mzg1NzFjMDBjNjg2MDk0
ZWZhN2NjNApkNDExNzRmYWJkYWUzNDhjNjU4M2NmMDVhZWIzMjlkYTIzMmMzNDJjCjkzMjBiNWM0
YTcyNjBkOTU5MzEwMmYzNzgyMDFkMTdlM2YwMzA3MzkK
--0016362843d61cd5fb049670d3ac
Content-Type: application/x-sh; name="revert_ath5k-patches.sh"
Content-Disposition: attachment; filename="revert_ath5k-patches.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gh7x54jn2

IyEvYmluL3NoCgp0YXIgLXhmIGZpbGVzL2xpbnV4LW5leHRfZ2l0X25leHQtMjAxMDEyMDIudGFy
CgpjZCBsaW51eC1uZXh0CgpnaXQgYnJhbmNoIHJldmVydC1hdGg1ay1wYXRjaGVzCmdpdCBjaGVj
a291dCByZXZlcnQtYXRoNWstcGF0Y2hlcwoKZm9yIGkgaW4gJChjYXQgLi4vcmV2ZXJ0X2F0aDVr
X3BhdGNoZXMubGlzdCkgOyBkbyBlY2hvICRpIDsgZ2l0IHJldmVydCAtLW5vLWVkaXQgJGkgOyBk
b25lCgo=
--0016362843d61cd5fb049670d3ac--
