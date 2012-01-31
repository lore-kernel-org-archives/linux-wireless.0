Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50764 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab2AaF6q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 00:58:46 -0500
Received: by vbbfc26 with SMTP id fc26so3542885vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 21:58:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAJ3AHeF5-yD_+a6HiA3Ty-yjizM4hOqS+nnZimbJULuX0s--A@mail.gmail.com>
References: <CAAJ3AHeF5-yD_+a6HiA3Ty-yjizM4hOqS+nnZimbJULuX0s--A@mail.gmail.com>
Date: Tue, 31 Jan 2012 11:28:45 +0530
Message-ID: <CAD2nsn2RTzkx_1ApoyPixfim6j5sY7kscW4QAzoVu49HyTNJjA@mail.gmail.com> (sfid-20120131_065849_985506_EBC2D754)
Subject: Re:
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Laurent Bonnans <bonnans.l@gmail.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Content-Type: multipart/mixed; boundary=bcaec5016409eba7b204b7cca7f8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--bcaec5016409eba7b204b7cca7f8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 31, 2012 at 1:13 AM, Laurent Bonnans <bonnans.l@gmail.com> wrot=
e:
> Since the update from linux 3.2.1 to 3.2.2, dhcp stopped working on
> some APs on my laptop with an AR9285 Wireless card.
>
> dhcp works fine on an open wifi network but receives no response on a
> wep network I use. I haven't been able to test it on a third network
> for now.

 reverting  "ath9k_hw: fix interpretation of the rx KeyMiss flag" does
helps.  i  need to analyze
if it exposes some real issue which need to be fixed.


> Reverting to 3.2.1 solved the issue which is still there in the latest
> git revision as of today.
>
> DHCPDISCOVER requests are still sent but no ACK is received (nothing
> in Wireshark).
>
> dhcp failure may be one particular instance of the problem but I
> haven't been able to connect with a static ip (my ap doesn't like it)
> so this is the
> only result I know.
>
>
> ver_linux output (latest git kernel) :
>
> Linux litbox 3.3.0-rc1-hack-00383-g0a96265 #1 SMP PREEMPT Mon Jan 30
> 02:22:54 CET 2012 x86_64 Intel(R) Core(TM) i3 CPU M 370 @ 2.40GHz
> GenuineIntel GNU/Linux
>
> Gnu C=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 4.6.2
> Gnu make=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 3.82
> binutils=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.22.0.20111227
> util-linux=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.20.1
> mount=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 support
> module-init-tools=A0=A0=A0=A0=A0 4
> e2fsprogs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1.42
> jfsutils=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1.1.15
> reiserfsprogs=A0=A0=A0=A0=A0=A0=A0=A0=A0 3.6.21
> xfsprogs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 3.1.7
> pcmciautils=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 018
> PPP=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.4.5
> Linux C Library=A0=A0=A0=A0=A0=A0=A0 2.15
> Dynamic linker (ldd)=A0=A0 2.15
> Linux C++ Library=A0=A0=A0=A0=A0 so.6.0
> Procps=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 3.2.8
> Net-tools=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1.60
> Kbd=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1.15.3
> Sh-utils=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 8.15
> wireless-tools=A0=A0=A0=A0=A0=A0=A0=A0 29
> Modules Loaded=A0=A0=A0=A0=A0=A0=A0=A0 ipv6 cpufreq_ondemand fuse xts gf1=
28mul
> uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev
> v4l2_compat_ioctl32 media arc4 ath9k ath9k_common ath9k_hw nouveau
> ehci_hcd usbcore i915 snd_hda_codec_hdmi snd_hda_codec_realtek joydev
> ath ttm intel_ips mac80211 cfg80211 asus_laptop sparse_keymap rfkill
> drm_kms_helper drm snd_hda_intel snd_hda_codec snd_hwdep mxm_wmi
> psmouse i2c_algo_bit serio_raw i2c_core pcspkr input_polldev mei
> iTCO_wdt usb_common evdev intel_agp iTCO_vendor_support intel_gtt
> atl1c wmi video snd_pcm snd_page_alloc snd_timer snd soundcore thermal
> battery ac button tun kvm_intel kvm aes_x86_64 aes_generic
> acpi_cpufreq mperf processor freq_table ext4 crc16 jbd2 mbcache
> dm_crypt dm_mod sd_mod ahci libahci libata scsi_mod
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
shafi

--bcaec5016409eba7b204b7cca7f8
Content-Type: text/x-diff; charset=US-ASCII;
	name="0001-Revert-ath9k_hw-fix-interpretation-of-the-rx-KeyMiss.patch"
Content-Disposition: attachment;
	filename="0001-Revert-ath9k_hw-fix-interpretation-of-the-rx-KeyMiss.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gy2imbcr0

RnJvbSAxNzFlZjRkMDkyZDQ3YmY2M2IzM2IxZTRkNWVhZmQ0MzIwZTZiYjFkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNb2hhbW1lZCBTaGFmaSBTaGFqYWtoYW4gPG1vaGFtbWVkQHFj
YS5xdWFsY29tbS5jb20+CkRhdGU6IFR1ZSwgMzEgSmFuIDIwMTIgMTA6MzY6NDcgKzA1MzAKU3Vi
amVjdDogW1BBVENIXSBSZXZlcnQgImF0aDlrX2h3OiBmaXggaW50ZXJwcmV0YXRpb24gb2YgdGhl
IHJ4IEtleU1pc3MgZmxhZyIKClRoaXMgcmV2ZXJ0cyBjb21taXQgN2E1MzJmZTcxMzEyMTZhMDJj
ODFhNmMxYjFmODYzMmRhMTE5NWE1OC4KLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRo
OWsvYXI5MDAzX21hYy5jIHwgICAgNSArKy0tLQogZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0
aDlrL21hYy5jICAgICAgICB8ICAgIDUgKystLS0KIDIgZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRp
b25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2F0aC9hdGg5ay9hcjkwMDNfbWFjLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsv
YXI5MDAzX21hYy5jCmluZGV4IDA5YjhjOWQuLjg4YzgxYzUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9hcjkwMDNfbWFjLmMKKysrIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYXRoL2F0aDlrL2FyOTAwM19tYWMuYwpAQCAtNTU3LDExICs1NTcsMTAgQEAgaW50IGF0
aDlrX2h3X3Byb2Nlc3NfcnhkZXNjX2VkbWEoc3RydWN0IGF0aF9odyAqYWgsIHN0cnVjdCBhdGhf
cnhfc3RhdHVzICpyeHMsCiAJCQlyeHMtPnJzX3N0YXR1cyB8PSBBVEg5S19SWEVSUl9ERUNSWVBU
OwogCQllbHNlIGlmIChyeHNwLT5zdGF0dXMxMSAmIEFSX01pY2hhZWxFcnIpCiAJCQlyeHMtPnJz
X3N0YXR1cyB8PSBBVEg5S19SWEVSUl9NSUM7CisJCWlmIChyeHNwLT5zdGF0dXMxMSAmIEFSX0tl
eU1pc3MpCisJCQlyeHMtPnJzX3N0YXR1cyB8PSBBVEg5S19SWEVSUl9LRVlNSVNTOwogCX0KIAot
CWlmIChyeHNwLT5zdGF0dXMxMSAmIEFSX0tleU1pc3MpCi0JCXJ4cy0+cnNfc3RhdHVzIHw9IEFU
SDlLX1JYRVJSX0tFWU1JU1M7Ci0KIAlyZXR1cm4gMDsKIH0KIEVYUE9SVF9TWU1CT0woYXRoOWtf
aHdfcHJvY2Vzc19yeGRlc2NfZWRtYSk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9hdGgvYXRoOWsvbWFjLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvbWFjLmMK
aW5kZXggZTE5NmFiYS4uZmQzZjE5YyAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
YXRoL2F0aDlrL21hYy5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9tYWMu
YwpAQCAtNjE4LDExICs2MTgsMTAgQEAgaW50IGF0aDlrX2h3X3J4cHJvY2Rlc2Moc3RydWN0IGF0
aF9odyAqYWgsIHN0cnVjdCBhdGhfZGVzYyAqZHMsCiAJCQlycy0+cnNfc3RhdHVzIHw9IEFUSDlL
X1JYRVJSX0RFQ1JZUFQ7CiAJCWVsc2UgaWYgKGFkcy5kc19yeHN0YXR1czggJiBBUl9NaWNoYWVs
RXJyKQogCQkJcnMtPnJzX3N0YXR1cyB8PSBBVEg5S19SWEVSUl9NSUM7CisJCWlmIChhZHMuZHNf
cnhzdGF0dXM4ICYgQVJfS2V5TWlzcykKKwkJCXJzLT5yc19zdGF0dXMgfD0gQVRIOUtfUlhFUlJf
S0VZTUlTUzsKIAl9CiAKLQlpZiAoYWRzLmRzX3J4c3RhdHVzOCAmIEFSX0tleU1pc3MpCi0JCXJz
LT5yc19zdGF0dXMgfD0gQVRIOUtfUlhFUlJfS0VZTUlTUzsKLQogCXJldHVybiAwOwogfQogRVhQ
T1JUX1NZTUJPTChhdGg5a19od19yeHByb2NkZXNjKTsKLS0gCjEuNy4wLjQKCg==
--bcaec5016409eba7b204b7cca7f8--
