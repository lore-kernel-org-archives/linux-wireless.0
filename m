Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:42915 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3JMFVX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Oct 2013 01:21:23 -0400
Received: by mail-lb0-f169.google.com with SMTP id z5so4802326lbh.0
        for <linux-wireless@vger.kernel.org>; Sat, 12 Oct 2013 22:21:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOAOC6Z4rrH5mDtqsJ=fskFfbsUVCSBCOY0r-irbhg21uxDwew@mail.gmail.com>
References: <CAOAOC6YT=ek4S=s0YNqejD2iCdPYng6FnJ1ROegwWhmcVZhyOg@mail.gmail.com>
	<CANUX_P25P2LwMwA3HRaxGBCkPsDTs6cOymkM5P+t7B8132CExA@mail.gmail.com>
	<CAOAOC6YGEphx+qo43hSWd=24knae_UC=JViTuiEUTT4TuGix4g@mail.gmail.com>
	<CANUX_P2ihGK4EVYqWgDeKg2AxeLtJsNiQg6aEo86Zgvh61ywGg@mail.gmail.com>
	<CAOAOC6aBtHjanEte9BeH0=mAzu9=7ZXPA8LFaQNNunnBFWQmVg@mail.gmail.com>
	<CAOAOC6Z+8yoVA9b81EMdZtRkDBygAhudnRnr6+QCVCPQgZKWWg@mail.gmail.com>
	<CAOAOC6Z4rrH5mDtqsJ=fskFfbsUVCSBCOY0r-irbhg21uxDwew@mail.gmail.com>
Date: Sun, 13 Oct 2013 08:21:21 +0300
Message-ID: <CANUX_P33mT7FJHcLUu8NYYXc9tKPavpn2MTHdDEBqvzoEqPHTA@mail.gmail.com> (sfid-20131013_072128_026948_6A066AF1)
Subject: Re: pci-half-mini 7206 ac/bluetooth issues
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Tim Nelson <tim.l.nelson@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e011766e5a4b12904e89885fd
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--089e011766e5a4b12904e89885fd
Content-Type: text/plain; charset=ISO-8859-1

Hi,

please keep the wireless mailing list in the thread.


On Sat, Oct 12, 2013 at 9:05 PM, Tim Nelson <tim.l.nelson@gmail.com> wrote:
> I just got this after about an hour of pandora over my bluetooth:
>
> I had added the coex statement to the following config as well.  I
> will try seeing if perhaps compiling my own kernel by hand yields
> different results but I only get testing time on weekends outside of
> work so if you can give me some time, I will keep logs and see what my
> results are.  I may even get a second hardware card to ensure its not
> a hardware failure.
>
> root@nix-S405C:/home/nelsot08# more /etc/modprobe.d/iwlwifi.conf
> # /etc/modprobe.d/iwlwifi.conf
> # iwlwifi will dyamically load either iwldvm or iwlmvm depending on the
> # microcode file installed on the system.  When removing iwlwifi, first
> # remove the iwl?vm module and then iwlwifi.
> remove iwlwifi \
> (/sbin/lsmod | grep -o -e ^iwlmvm -e ^iwldvm -e ^iwlwifi | xargs /sbin/rmmod) \
> && /sbin/modprobe -r mac80211
> options iwlwifi bt_coex_active=0
>
> Oct 12 14:00:45 nix-S405C kernel: [50730.682750] WARNING: CPU: 2 PID: 893 at /bu
> ild/buildd/linux-3.11.0/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c:1033 iwl_mvm
> _mac_ctxt_add+0x87/0xa0 [iwlmvm]()
> Oct 12 14:00:45 nix-S405C kernel: [50730.682752] Adding active MAC 0c:8b:fd:32:d
> e:c6/2
> Oct 12 14:00:45 nix-S405C kernel: [50730.682754] Modules linked in: nfnetlink_qu
> eue(F) nfnetlink_log(F) nfnetlink(F) md4(F) nls_utf8 cifs(F) fscache(F) hidp hid
>  pci_stub vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF) vboxdrv(OF) dm_crypt(F) x86_
> pkg_temp_thermal intel_powerclamp coretemp kvm_intel(F) kvm(F) crc32_pclmul(F) a
> esni_intel(F) aes_i586(F) xts(F) lrw(F) gf128mul(F) ablk_helper(F) cryptd(F) snd
> _hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec joydev(F) uvcv
> ideo snd_hwdep(F) snd_pcm(F) videobuf2_vmalloc videobuf2_memops snd_page_alloc(F
> ) videobuf2_core snd_seq_midi(F) snd_seq_midi_event(F) arc4(F) snd_rawmidi(F) vi
> deodev snd_seq(F) snd_seq_device(F) snd_timer(F) iwlmvm asus_nb_wmi asus_wmi spa
> rse_keymap mac80211 btusb microcode(F) iwlwifi rtsx_pci_ms snd(F) soundcore(F) m
> ei_me psmouse(F) memstick mei cfg80211 serio_raw(F) lpc_ich mac_hid bnep rfcomm
> bluetooth parport_pc(F) ppdev(F) lp(F) parport(F) binfmt_misc(F) i915 rtsx_pci_s
> dmmc i2c_algo_bit drm_kms_helper drm r8169 ahci(F) libahci(F) mii(F) r
> Oct 12 14:00:45 nix-S405C kernel: tsx_pci wmi video(F)
> Oct 12 14:00:45 nix-S405C kernel: [50730.682803] CPU: 2 PID: 893 Comm: NetworkMa
> nager Tainted: GF       W  O 3.11.0-12-generic #19-Ubuntu
> Oct 12 14:00:45 nix-S405C kernel: [50730.682805] Hardware name: ASUSTeK COMPUTER
>  INC. K46CA/K46CA, BIOS K46CA.315 05/17/2013
> Oct 12 14:00:45 nix-S405C kernel: [50730.682807]  00000000 00000000 f0ff19b8 c16
> 2566b f0ff19f8 f0ff19e8 c105273e f91ed58f
> Oct 12 14:00:45 nix-S405C kernel: [50730.682812]  f0ff1a14 0000037d f91eb000 000
> 00409 f91d6567 f91d6567 f55c7cf4 f55c7c20
> Oct 12 14:00:45 nix-S405C kernel: [50730.682816]  00000000 f0ff1a00 c1052793 000
> 00009 f0ff19f8 f91ed58f f0ff1a14 f0ff1a20
> Oct 12 14:00:45 nix-S405C kernel: [50730.682821] Call Trace:
> Oct 12 14:00:45 nix-S405C kernel: [50730.682827]  [<c162566b>] dump_stack+0x41/0
> x52
> Oct 12 14:00:45 nix-S405C kernel: [50730.682831]  [<c105273e>] warn_slowpath_com
> mon+0x7e/0xa0
> Oct 12 14:00:45 nix-S405C kernel: [50730.682839]  [<f91d6567>] ? iwl_mvm_mac_ctx
> t_add+0x87/0xa0 [iwlmvm]

This looks like a side effect of the first issue (commands that fail
on timeout).
 Could you return to the default configuration (don't disable bt_coex
nor powersave), apply the attached patch and report back?
Thanks.

--089e011766e5a4b12904e89885fd
Content-Type: application/octet-stream;
	name="0001-iwlwifi-pcie-poke-device-when-commands-don-t-complet.patch"
Content-Disposition: attachment;
	filename="0001-iwlwifi-pcie-poke-device-when-commands-don-t-complet.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hmpts5o30

RnJvbSAyYmY1MTdhYThkYThkOWM0OWVkZGMyMWUyYWRiYjBiYmUxMzYzZjkxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKb2hhbm5lcyBCZXJnIDxqb2hhbm5lcy5iZXJnQGludGVsLmNv
bT4KRGF0ZTogV2VkLCA5IE9jdCAyMDEzIDA5OjU5OjI1ICswMjAwClN1YmplY3Q6IFtQQVRDSF0g
aXdsd2lmaTogcGNpZTogcG9rZSBkZXZpY2Ugd2hlbiBjb21tYW5kcyBkb24ndCBjb21wbGV0ZQog
cXVpY2tseQoKSW4gY2VydGFpbiBjb3JuZXIgY2FzZXMgaW4gdGhlIGZpcm13YXJlIGltcGxlbWVu
dGF0aW9uLCBwb3dlcnNhdmUKdHJhbnNpdGlvbnMgY2FuIGNhdXNlIHRoZSBmaXJtd2FyZSB0byBt
aXNzIHRoZSBmYWN0IHRoYXQgY29tbWFuZHMKd2VyZSBhZGRlZCB0byB0aGUgcXVldWUvRklGTyBh
bmQgdGh1cyBuZXZlciBwcm9jZXNzZXMgdGhlbS4gU2luY2UKdGhlIGNvbW1hbmRzIHJlYWxseSBh
cmUgaW4gdGhlIHF1ZXVlLCB0cnkgdG8gcG9rZSB0aGUgZmlybXdhcmUgaW4Kc3VjaCBjYXNlcyAo
YnkgZ3JhYmJpbmcgTklDIGFjY2Vzcywgd2hpY2ggd2FrZXMgdXAgdGhlIE5JQykgc28gaXQKbm90
aWNlcyB0aGUgbmV3IGNvbW1hbmQgYW5kIHByb2Nlc3NlcyBpdC4KClNpZ25lZC1vZmYtYnk6IEpv
aGFubmVzIEJlcmcgPGpvaGFubmVzLmJlcmdAaW50ZWwuY29tPgotLS0KIGRyaXZlcnMvbmV0L3dp
cmVsZXNzL2l3bHdpZmkvcGNpZS90eC5jIHwgMzEgKysrKysrKysrKysrKysrKysrKysrKysrKyst
LS0tLQogMSBmaWxlIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9wY2llL3R4LmMgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL3BjaWUvdHguYwppbmRleCA1YWQwODcxLi41MTk5ZmJh
IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL3BjaWUvdHguYworKysg
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL3BjaWUvdHguYwpAQCAtMTQ3MSw3ICsxNDcx
LDggQEAgdm9pZCBpd2xfcGNpZV9oY21kX2NvbXBsZXRlKHN0cnVjdCBpd2xfdHJhbnMgKnRyYW5z
LAogCXNwaW5fdW5sb2NrX2JoKCZ0eHEtPmxvY2spOwogfQogCi0jZGVmaW5lIEhPU1RfQ09NUExF
VEVfVElNRU9VVCAoMiAqIEhaKQorI2RlZmluZSBIT1NUX0NPTVBMRVRFX1RJTUVPVVQJKDIgKiBI
WikKKyNkZWZpbmUgQ09NTUFORF9QT0tFX1RJTUVPVVQJKEhaIC8gMTApCiAKIHN0YXRpYyBpbnQg
aXdsX3BjaWVfc2VuZF9oY21kX2FzeW5jKHN0cnVjdCBpd2xfdHJhbnMgKnRyYW5zLAogCQkJCSAg
ICBzdHJ1Y3QgaXdsX2hvc3RfY21kICpjbWQpCkBAIC0xNDk5LDYgKzE1MDAsNyBAQCBzdGF0aWMg
aW50IGl3bF9wY2llX3NlbmRfaGNtZF9zeW5jKHN0cnVjdCBpd2xfdHJhbnMgKnRyYW5zLAogCXN0
cnVjdCBpd2xfdHJhbnNfcGNpZSAqdHJhbnNfcGNpZSA9IElXTF9UUkFOU19HRVRfUENJRV9UUkFO
Uyh0cmFucyk7CiAJaW50IGNtZF9pZHg7CiAJaW50IHJldDsKKwlpbnQgdGltZW91dCA9IEhPU1Rf
Q09NUExFVEVfVElNRU9VVDsKIAogCUlXTF9ERUJVR19JTkZPKHRyYW5zLCAiQXR0ZW1wdGluZyB0
byBzZW5kIHN5bmMgY29tbWFuZCAlc1xuIiwKIAkJICAgICAgIGdldF9jbWRfc3RyaW5nKHRyYW5z
X3BjaWUsIGNtZC0+aWQpKTsKQEAgLTE1MjMsMTAgKzE1MjUsMjkgQEAgc3RhdGljIGludCBpd2xf
cGNpZV9zZW5kX2hjbWRfc3luYyhzdHJ1Y3QgaXdsX3RyYW5zICp0cmFucywKIAkJcmV0dXJuIHJl
dDsKIAl9CiAKLQlyZXQgPSB3YWl0X2V2ZW50X3RpbWVvdXQodHJhbnNfcGNpZS0+d2FpdF9jb21t
YW5kX3F1ZXVlLAotCQkJCSAhdGVzdF9iaXQoU1RBVFVTX0hDTURfQUNUSVZFLAotCQkJCQkgICAm
dHJhbnNfcGNpZS0+c3RhdHVzKSwKLQkJCQkgSE9TVF9DT01QTEVURV9USU1FT1VUKTsKKwl3aGls
ZSAodGltZW91dCA+IDApIHsKKwkJdW5zaWduZWQgbG9uZyBmbGFnczsKKworCQl0aW1lb3V0IC09
IENPTU1BTkRfUE9LRV9USU1FT1VUOworCQlyZXQgPSB3YWl0X2V2ZW50X3RpbWVvdXQodHJhbnNf
cGNpZS0+d2FpdF9jb21tYW5kX3F1ZXVlLAorCQkJCQkgIXRlc3RfYml0KFNUQVRVU19IQ01EX0FD
VElWRSwKKwkJCQkJCSAgICZ0cmFuc19wY2llLT5zdGF0dXMpLAorCQkJCQkgQ09NTUFORF9QT0tF
X1RJTUVPVVQpOworCQlpZiAocmV0KQorCQkJYnJlYWs7CisJCS8qIHBva2UgdGhlIGRldmljZSAt
IGl0IG1heSBoYXZlIGxvc3QgdGhlIGNvbW1hbmQgKi8KKwkJaWYgKGl3bF90cmFuc19ncmFiX25p
Y19hY2Nlc3ModHJhbnMsIHRydWUsICZmbGFncykpIHsKKwkJCWl3bF90cmFuc19yZWxlYXNlX25p
Y19hY2Nlc3ModHJhbnMsICZmbGFncyk7CisJCQlJV0xfREVCVUdfSU5GTyh0cmFucywKKwkJCQkg
ICAgICAgIlRyaWVkIHRvIHdha2UgTklDIGZvciBjb21tYW5kICVzXG4iLAorCQkJCSAgICAgICBn
ZXRfY21kX3N0cmluZyh0cmFuc19wY2llLCBjbWQtPmlkKSk7CisJCX0gZWxzZSB7CisJCQlJV0xf
RVJSKHRyYW5zLCAiRmFpbGVkIHRvIHBva2UgTklDIGZvciBjb21tYW5kICVzXG4iLAorCQkJCWdl
dF9jbWRfc3RyaW5nKHRyYW5zX3BjaWUsIGNtZC0+aWQpKTsKKwkJCWJyZWFrOworCQl9CisJfQor
CiAJaWYgKCFyZXQpIHsKIAkJaWYgKHRlc3RfYml0KFNUQVRVU19IQ01EX0FDVElWRSwgJnRyYW5z
X3BjaWUtPnN0YXR1cykpIHsKIAkJCXN0cnVjdCBpd2xfdHhxICp0eHEgPQotLSAKMS44LjEubXN5
c2dpdC4xCgo=
--089e011766e5a4b12904e89885fd--
