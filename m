Received: from forward206a.mail.yandex.net (forward206a.mail.yandex.net [178.154.239.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6277B37A856;
	Thu,  3 Sep 2026 04:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788409846; cv=none; b=L3pXsjQCSLR0Lm34/cTCRVmzeg1bpb+5Or5BJOTbPUnh/P8iAhRb6SlkxeVVE1IerCEoqs8CoQ12fx9RrWRk/hGsoovDTR/oJ+Q1/rOmie4WY8eST6KvfkA0XZhxrcNxE87yGWTOdb+nmteMZzREOJgfyhVl7NOsPyWISc7muRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788409846; c=relaxed/simple;
	bh=ORdag3CCI5zqJKQuC0TkIJG0A2D0ZDZE84Pojx+wsI4=;
	h=From:To:MIME-Version:Date:Message-Id:Content-Type; b=RtzoSrTh/LFKop+OpSYPubCa9dQviYv87syz/2Ei2dht8bQyuIeTyI0Mmrprb+yCrQdi+qV/XNsaLLkAeSqVdXfoCP1aGINPyYNLvZok4xGP7v/6ZCKWUyNDnlfLSOzGFe7okrEVKQJW4X2HT5jJh28svQ1YpNtDZwjDhlee6DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=fail smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=C4E7k/x8; arc=none smtp.client-ip=178.154.239.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="C4E7k/x8"
Received: from forward101a.mail.yandex.net (forward101a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d101])
	by forward206a.mail.yandex.net (postfix) with ESMTPS id 0EA1F8502B;
	Thu, 03 Sep 2026 07:23:00 +0300 (MSK)
Received: from mail-nwsmtp-mxback-production-main-25.vla.yp-c.yandex.net (mail-nwsmtp-mxback-production-main-25.vla.yp-c.yandex.net [IPv6:2a02:6b8:c18:d0c:0:640:b1cd:0])
	by forward101a.mail.yandex.net (postfix) with ESMTPS id 4280780D7F;
	Thu, 03 Sep 2026 07:22:52 +0300 (MSK)
Received: from mail.yandex.ru (2a02:6b8:c0d:a1:0:640:bafe:0 [2a02:6b8:c0d:a1:0:640:bafe:0])
	by mail-nwsmtp-mxback-production-main-25.vla.yp-c.yandex.net (mxback) with HTTPS id iMcCWxDvx4Y0-JKqugUkQ;
	Thu, 03 Sep 2026 07:22:51 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1788409371; bh=0zthGu/O1Qmz5rOXIIwyBD8+qtWp+/uaNg6P1907Xt8=;
	h=Message-Id:Date:To:From;
	b=C4E7k/x8Wk3zqm2UwAEynK+y5CcDlYBGGh4FoDmmuNbDadGfpDL/je0/FFzWZqHQX
	 Lgn/iYFcoCtUjZtp+sFfzXeEAthN4LNXBgx62EFujlhf1ZacyzJyKyVcrPYAJRrcAF
	 DImKh/DDAU80kexWmEKYBFws1znkCz5WaTUo99nI=
Authentication-Results: mail-nwsmtp-mxback-production-main-25.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by megd36izw2gubgrl.vla.yp-c.yandex.net (sendbernar) with HTTPS id 334c9e58a6dbfccd86f589bac3512048;
	Thu, 03 Sep 2026 07:22:51 +0300
From: =?utf-8?B?0JPQtdGA0LzQsNC9INCh0LXQvNGR0L3QvtCy?= <GermanAizek@yandex.ru>
To: Jakub Kicinski <kuba@kernel.org>,
	Kalle Valo <kvalo@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 03 Sep 2026 07:22:51 +0300
Message-Id: <795111788409331@mail.yandex.ru>
Content-Type: multipart/mixed;
	boundary="----==--bound.101862.e14820d5-73c5-4cab-99d4-52f319dab817"


------==--bound.101862.e14820d5-73c5-4cab-99d4-52f319dab817
Content-Disposition: attachment;
	filename="0001-PATCH-wifi-mt7601u-add-vnd_reset-parameter-to-fix-pr.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-diff;
	name="0001-PATCH-wifi-mt7601u-add-vnd_reset-parameter-to-fix-pr.patch"

RnJvbSBjMDNkNzNkMzdkZjQ0MGQwMDQ2ZDY4NDA2ZmRlMmFhMWY2MmZlMGQxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBIZXJtYW4gU2VtZW5vZmYgPEdlcm1hbkFpemVrQHlhbmRleC5y
dT4KRGF0ZTogVGh1LCAzIFNlcCAyMDI2IDA3OjE0OjMyICswMzAwClN1YmplY3Q6IFtQQVRDSF0g
W1BBVENIXSB3aWZpOiBtdDc2MDF1OiBhZGQgdm5kX3Jlc2V0IHBhcmFtZXRlciB0byBmaXggcHJv
YmUKIGZhaWx1cmUgb24gVGVuZGEgVTIKCndpZmk6IG10NzYwMXU6IGFkZCB2bmRfcmVzZXQgcGFy
YW1ldGVyIHRvIGZpeCBwcm9iZSBmYWlsdXJlIG9uIFRlbmRhIFUyCgpPbiBjZXJ0YWluIE1UNzYw
MVUgYWRhcHRlcnMsIHN1Y2ggYXMgVGVuZGEgVTIgYW5kCm90aGVyIG5ld2VyIGhhcmR3YXJlIHJl
dmlzaW9ucywgZHJpdmVyIGluaXRpYWxpemF0aW9uIGNvbnNpc3RlbnRseSBmYWlscwpkdXJpbmcg
cHJvYmUgd2l0aCB2ZW5kb3IgcmVxdWVzdCB0aW1lb3V0cyAoLTExMCAvIC1FVElNRURPVVQpOgog
IG10NzYwMXUgMy0xNDoxLjA6IEFTSUMgcmV2aXNpb246IDc2MDEwMDAxIE1BQyByZXZpc2lvbjog
NzYwMTA1MDAKICBtdDc2MDF1IDMtMTQ6MS4wOiBGaXJtd2FyZSBWZXJzaW9uOiAwLjEuMDAgQnVp
bGQ6IDc2NDAgQnVpbGQgdGltZTogMjAxMzAyMDUyMTQ2X19fXwogIG10NzYwMXUgMy0xNDoxLjA6
IFZlbmRvciByZXF1ZXN0IHJlcTowNyBvZmY6MDlhOCBmYWlsZWQ6LTExMAogIG10NzYwMXUgMy0x
NDoxLjA6IFZlbmRvciByZXF1ZXN0IHJlcTowMiBvZmY6MDlhOCBmYWlsZWQ6LTExMAogIG10NzYw
MXUgMy0xNDoxLjA6IFZlbmRvciByZXF1ZXN0IHJlcTowNyBvZmY6MDczNCBmYWlsZWQ6LTExMAog
IG10NzYwMXUgMy0xNDoxLjA6IFZlbmRvciByZXF1ZXN0IHJlcTo0MiBvZmY6MDIzMCBmYWlsZWQ6
LTExMAogIG10NzYwMXUgMy0xNDoxLjA6IHByb2JlIHdpdGggZHJpdmVyIG10NzYwMXUgZmFpbGVk
IHdpdGggZXJyb3IgLTExMAoKVGhlIGZhaWx1cmUgb2NjdXJzIGJlY2F1c2UgbXQ3NjAxdV9sb2Fk
X2Zpcm13YXJlKCkgdW5jb25kaXRpb25hbGx5IGNhbGxzCm10NzYwMXVfdmVuZG9yX3Jlc2V0KCkg
KE1UX1ZFTkRfREVWX01PREVfUkVTRVQpIGJlZm9yZSB1cGxvYWRpbmcgZmlybXdhcmUKY2h1bmtz
LiBPbiB0aGVzZSBkZXZpY2VzLCBpc3N1aW5nIHRoaXMgdmVuZG9yIHJlc2V0IGxlYXZlcyB0aGUg
aW50ZXJuYWwKTUNVIC8gRkNFIERNQSBlbmdpbmUgaW4gYW4gdW5yZXNwb25zaXZlIHN0YXRlIGFm
dGVyIHRoZSBmaXJzdCBmaXJtd2FyZQpVUkIgaXMgc3VibWl0dGVkLiBBcyBhIHJlc3VsdCwgcmVh
ZGluZyBNVF9UWF9DUFVfRlJPTV9GQ0VfQ1BVX0RFU0NfSURYCigweDA5YTgpIGltbWVkaWF0ZWx5
IHRpbWVzIG91dC4KSW50cm9kdWNlIGEgYm9vbGVhbiBtb2R1bGUgcGFyYW1ldGVyICd2bmRfcmVz
ZXQnIChkZWZhdWx0OiBmYWxzZSkgdG8KbWFrZSB0aGlzIHZlbmRvciByZXNldCBvcHRpb25hbC4g
V2hlbiB0aGUgdmVuZG9yIHJlc2V0IGlzIHNraXBwZWQsCmZpcm13YXJlIHVwbG9hZCBzdWNjZWVk
cyBhbmQgdGhlIHdpcmVsZXNzIGludGVyZmFjZSBpbml0aWFsaXplcyBub3JtYWxseS4KCkxpbms6
IGh0dHBzOi8vYnVncy5sYXVuY2hwYWQubmV0L3VidW50dS8rc291cmNlL2xpbnV4LytidWcvMTcx
NjMwMQoKTW9yZSBpc3N1ZXMgd2l0aCBUZW5kYSBVMiBhbmQgTGludXg6Ci0gaHR0cHM6Ly93d3cu
b3BlbmEudHYvdmlld3RvcGljLnBocD90PTYzOTE5Ci0gaHR0cHM6Ly9hc2t1YnVudHUuY29tL3F1
ZXN0aW9ucy8xNDE4ODUwL3RoZS1wcm9ibGVtLXdpdGgtd2ktZmktdTIKLSBodHRwczovL2Jicy5h
cmNobGludXgub3JnL3ZpZXd0b3BpYy5waHA/aWQ9MjI0ODU5Ci0gaHR0cHM6Ly93d3cucmVkZGl0
LmNvbS9yL2FyY2hsaW51eC9jb21tZW50cy8xZDZkZnY1L210NzYwMXVfdXNiX3dpZmlfbm90X3dv
cmtpbmcvCgpTaWduZWQtb2ZmLWJ5OiBIZXJtYW4gU2VtZW5vZmYgPEdlcm1hbkFpemVrQHlhbmRl
eC5ydT4KLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2MDF1L21jdS5jIHwg
MTUgKysrKysrKysrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRlay9t
dDc2MDF1L21jdS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3NjAxdS9tY3Uu
YwppbmRleCBiYWQ2Y2E4MjEuLmFiZjQ3NjdmMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvbWVkaWF0ZWsvbXQ3NjAxdS9tY3UuYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9t
ZWRpYXRlay9tdDc2MDF1L21jdS5jCkBAIC0xMCw2ICsxMCw3IEBACiAjaW5jbHVkZSA8bGludXgv
ZGVsYXkuaD4KICNpbmNsdWRlIDxsaW51eC91c2IuaD4KICNpbmNsdWRlIDxsaW51eC9za2J1ZmYu
aD4KKyNpbmNsdWRlIDxsaW51eC9tb2R1bGVwYXJhbS5oPgogCiAjaW5jbHVkZSAibXQ3NjAxdS5o
IgogI2luY2x1ZGUgImRtYS5oIgpAQCAtMjEsNiArMjIsMTQgQEAKICNkZWZpbmUgTUNVX0ZXX1VS
Ql9TSVpFCQkJKE1DVV9GV19VUkJfTUFYX1BBWUxPQUQgKyAxMikKICNkZWZpbmUgTUNVX1JFU1Bf
VVJCX1NJWkUJCTEwMjQKIAorc3RhdGljIGJvb2wgdm5kX3Jlc2V0OworbW9kdWxlX3BhcmFtKHZu
ZF9yZXNldCwgYm9vbCwgMDY0NCk7CitNT0RVTEVfUEFSTV9ERVNDKHZuZF9yZXNldCwgIlBlcmZv
cm0gdmVuZG9yIHJlc2V0IGR1cmluZyBmaXJtd2FyZSB1cGxvYWQgKGRlZmF1bHQ6IGZhbHNlKSIp
OworCitzdGF0aWMgYm9vbCBkaXNhYmxlX3VzYl9zZzsKK21vZHVsZV9wYXJhbShkaXNhYmxlX3Vz
Yl9zZywgYm9vbCwgMDY0NCk7CitNT0RVTEVfUEFSTV9ERVNDKGRpc2FibGVfdXNiX3NnLCAiVW51
c2VkIGNvbXBhdGliaWxpdHkgcGFyYW1ldGVyIik7CisKIHN0YXRpYyBpbmxpbmUgaW50IGZpcm13
YXJlX3J1bm5pbmcoc3RydWN0IG10NzYwMXVfZGV2ICpkZXYpCiB7CiAJcmV0dXJuIG10NzYwMXVf
cnIoZGV2LCBNVF9NQ1VfQ09NX1JFRzApID09IDE7CkBAIC00NTksOCArNDY4LDEwIEBAIHN0YXRp
YyBpbnQgbXQ3NjAxdV9sb2FkX2Zpcm13YXJlKHN0cnVjdCBtdDc2MDF1X2RldiAqZGV2KQogCW10
NzYwMXVfd3IoZGV2LCAweDk0YywgMCk7CiAJbXQ3NjAxdV93cihkZXYsIE1UX0ZDRV9QU0VfQ1RS
TCwgMCk7CiAKLQltdDc2MDF1X3ZlbmRvcl9yZXNldChkZXYpOwotCW1zbGVlcCg1KTsKKwlpZiAo
dm5kX3Jlc2V0KSB7CisJCW10NzYwMXVfdmVuZG9yX3Jlc2V0KGRldik7CisJCW1zbGVlcCg1KTsK
Kwl9CiAKIAltdDc2MDF1X3dyKGRldiwgMHhhNDQsIDApOwogCW10NzYwMXVfd3IoZGV2LCAweDIz
MCwgMHg4NDIxMCk7Ci0tIAoyLjU1LjAKCg==
------==--bound.101862.e14820d5-73c5-4cab-99d4-52f319dab817--
