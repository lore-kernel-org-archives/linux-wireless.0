Received: from mail-ed2-f32.google.com (mail-ed2-f32.google.com [74.125.228.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5603254704E
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 00:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.96
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791247729; cv=pass; b=WRypx+zOYpajg+1kxDGIK/VEMuFsezeD0n6zu1hD8rV/yJjAPH+gPbWPYb3B/GYeJqDRQBkDJhEqOqDBjF7BD6Znc3ltNMV2SV6bYVwCQdJ4qOMcCEKlsDv2Q9luj+CvokIa2yXKmFxa6GEF1qmPNkj1PyHRxCXmA9rrxw0Kb5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791247729; c=relaxed/simple;
	bh=0tLx+KDwJdfF+0nZAgbylxp6lNrARa/+GK+b24bNsmo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=f5bJXkNyw2zBnBr9npp3oyL5LYdOV1Km+Su6zUrwImNfLWgp9xLchYtCo055574GlBo6xdjiQmDZtsoNn5bgGJmSoSxx1waE4EjdwOAQfWiawSggUMz8mXY4N8Gz5U/zP5z9jFH+ltcXSWQK86+JBb6s8yMd+pZywJEY47DHImw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZMkP9pDT; arc=pass smtp.client-ip=74.125.228.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZMkP9pDT"
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6ad186afdf4so4200162a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 17:48:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791247725; cv=none;
        d=google.com; s=arc-20260327;
        b=aMmk13EB2Zg2mMkXyjl3AMaF2vfXlDIWZsQuoM4Cno7C57dPMuXugZACp6V2IJ3v/4
         7VegoAJHZlxPMBgJnjwAiyjIFtmyVtzbKM+c/uBvaFVbWpNWB9ZHAcwTCmveRj3lRQE7
         nQAOtckULWme9lhSFr9/yr63XjnUnds+5BIrktZu4aeEhPq6Be2Svt3lodX7JuEvI3zK
         UYu1McHYLJol9oWOsJwIsHiNyzTlY6NsOQOCT/n4Hj+9+F4XM4Wr7dzHSASPhedkf/cy
         Te7c01pr2INCAjRRajp2QTv4QkpwrBCfadjTD0pj3qP+P9qhPTPuliplG8PF7l8HpERX
         oxeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=yDjkbz5Ffu37NcoZjmNPGwdYZSoz7x9/XIZnhgKJqto=;
        fh=unOd+iR/s4g3ccNRscfqoIvCvfbfQt24cpkffWnNbx8=;
        b=KmpzJIm1QElEgDiK4kGXXrlljyC1Sgzv+aSCxqMYYVq/7rSdIJy1w5cxtOd0myhEno
         Pvwm+vhk2Tc4+ZZ+LlY/oWpZCHjDuUWYk6PLyQukqiewzZbTWXmknil38RO1XmvTIFuf
         RP3LqFOmi0s++i45srS8WytfFb5imA2aIp+LV0KuB3nzliI7/wrHygQO2+CXO9a8Sl/O
         2R+k3nuQ8FT0NO4N0BodnUKy4mRVrA+oFshMUh6MWwrjTVAleAtoWumFyLrs64MjZXkv
         3QYsPEkTxqntgxjpmn6w0j4Z8T9Ldi1lEpwByNsSBOhUHjjw0lQJ3sloZRylac5zA1Cu
         dGOg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791247725; x=1791852525; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yDjkbz5Ffu37NcoZjmNPGwdYZSoz7x9/XIZnhgKJqto=;
        b=ZMkP9pDTGps/3GPUTr5Ll8JDXpm2q11mUyosW3JxNrs188ON3Y91iMhfUsTLfL2GMi
         a+UaeDVsxql6X1yWkkpNEJRLLBrcUSbwwZY3ZJLUiEPp68fDegteILYiVg0GlAMdpT2o
         MzllZFrfnLiyVN9wwgmcwdyhS7TiJYD+EbT1l9twjLp7R+MBG1nd278ZG/fLh2Xw+z9a
         Jj8BQ+1xbVAg0pRqUDfnlAM7mfEgPQ14FWcog3g0m3n8m5rw81eH0HWlahTH5/hpR3ZJ
         L01xuPZDbwzL7ANjbZcDaDsITqdjio8a8ibKw5SFrMivYTrLKqlzVOMsbSnLwpZdde9L
         +YkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791247725; x=1791852525;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=yDjkbz5Ffu37NcoZjmNPGwdYZSoz7x9/XIZnhgKJqto=;
        b=fiLMdK4ld2pA+L5wpbqDjmOT/+tc+nUMkvhQ03YYtHvkUzn1XtcIoccNUf8FajVnvk
         JJHNfyqdj21xvJ91TnPOkWX/Xv4XL9e4W6mId/Y0og+I1Lj5tDpH/AP7iOaSf1dimMmj
         h/L0t3o0WUfPy4TRntTzoL3v5V4+VkJbbPT3gPno0kdFIbRdx1RfewDYWqdbiRPJQC6J
         m4ViTtJlLD8Hj1nlq23x4xpDNJ0Qd35Z/EKRJSyRz3jZ80UJHH6NJz//tCHzBxkcCRsh
         6c8QcWSidykKtsshMp4fJWJ5vpBHfMj2z05rDsPSEAX19ORCPlsRNBzB9aIRpZaDBZjS
         7MGg==
X-Gm-Message-State: AFq9FYKLeVztnzP739BYehXg4fXwyHvr13Wb2ujuTxfzJJyNXrq3JPAZ
	oO0cg2oqEl+ph28hGglcd6drG05vNUgvka+1uD0rls/oljcqVkIJr+J+K7+VBS6mycSIsJZvtu3
	NI0vDtUcW4lCuaQ55pom60RSufUiqEl2U8Q==
X-Gm-Gg: AYBFou2AUpZpTbukbmOLX2qbxBWnlRfnwt259dXNF0SpPh+YoKqbT+G0weIKXSvWFdK
	azaJGk27a3qDAoo1uYkDhvzYxwlqQZK42qcQZ+++FiJ0oqzduDA2bGQ9OT7UHj+iGy8JHoJka+u
	jvSIwfq4Any1K7j6py04hAX2Yy3Frx+GsKX89NfOkaNgUeq4S6grC0I2NEMeoKezmp/mTkNB4zG
	9ABBZGjRYHtgrSKl+ZD3my/3rJ1JB3HFsZ/KXSBySDibFIAEhYBXzeHR7xY3htBhIiJAMqfXL+Y
	PnI65fy979LexROqsaa++ehPO8o2DjfU07LxFF5gAPaoM0r1pTM2BA==
X-Received: by 2002:a05:6402:52c1:b0:6ae:550e:59ee with SMTP id
 4fb4d7f45d1cf-6af9e30f5a0mr8429990a12.36.1791247725128; Mon, 05 Oct 2026
 17:48:45 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Mon, 5 Oct 2026 19:48:43 -0500
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Mon, 5 Oct 2026 19:48:43 -0500
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: John <dencity7@gmail.com>
Date: Mon, 5 Oct 2026 19:48:43 -0500
X-Gm-Features: AclHuK_Vy8K4gIsWI-19h33_M_T_ZH88YlsvURlXGiTBf8wG93VYcI5ALVd6YmU
Message-ID: <CA+KzPsr13czsH=k_UWJqj48C4Vsb-diQ-tiCh7W4XW31E8WzHg@mail.gmail.com>
Subject: [RFC PATCH] wifi: ath12k: service all RX rings in an interrupt group
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000005ca053065d215c6e"

--0000000000005ca053065d215c6e
Content-Type: text/plain; charset="UTF-8"

An RX interrupt group may select multiple receive rings. The Wi-Fi 7
handler currently services only the highest set bit, even when the NAPI
budget has room for work from another selected ring. Walk all selected
bits and retain the shared budget and existing early-exit behavior.

On a locally adapted GL-BE3600/QCN6432, group 5 selects bits 2 and 3. A
host regression built from the actual RX block completes 3 of 6 queued
packets before the fix and 6 of 6 after it. Single-ring, empty-mask and
two-poll budget cases pass. Descending priority is unchanged; this does
not establish fairness under sustained traffic.

Signed-off-by: John <dencity7@gmail.com>

---
RFC validation and limits:

Source applicability and the host regression were checked against
backports 7.2 plus the 230 wireless patches from perceival/openwrt-flint3
commit 2365932733ca8ec3b346621d9cec2eb3df3b2cf3. The new patch applies
with zero fuzz. The same source-block regression and exact patch
application also pass against official ath.git main at
388d3c42e8aba1cfc3c6d2c52877a46d8cf740db (zero fuzz). No full module
build or hardware test was performed against either current revision.

Historical tests on Linux 6.18.39 with local backports 7.2-rc4/QCN6432
changes passed DHCP, DNS, 32 UDP flows and about 181 seconds of traffic
after reboot. These are bounded observations, not throughput or long-term
stability qualification. The contribution was developed with AI assistance.

--- a/drivers/net/wireless/ath/ath12k/wifi7/dp.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp.c
@@ -52,8 +52,10 @@
 			goto done;
 	}

-	if (dp->hw_params->ring_mask->rx[grp_id]) {
-		i = fls(dp->hw_params->ring_mask->rx[grp_id]) - 1;
+	ring_mask = dp->hw_params->ring_mask->rx[grp_id];
+	while (ring_mask) {
+		i = fls(ring_mask) - 1;
+		ring_mask &= ~BIT(i);
 		work_done = ath12k_wifi7_dp_rx_process(dp, i, napi, budget);
 		budget -= work_done;
 		tot_work_done += work_done;

--0000000000005ca053065d215c6e
Content-Type: text/plain; charset="utf-8"; name="0001-ath12k-service-all-rx-rings.patch"
Content-Disposition: attachment; 
	filename="0001-ath12k-service-all-rx-rings.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: 4c74fd0121bf6498_0.1

RnJvbTogSm9obiA8ZGVuY2l0eTdAZ21haWwuY29tPg0KVG86IGF0aDEya0BsaXN0cy5pbmZyYWRl
YWQub3JnDQpDYzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBbUkZD
IFBBVENIXSB3aWZpOiBhdGgxMms6IHNlcnZpY2UgYWxsIFJYIHJpbmdzIGluIGFuIGludGVycnVw
dCBncm91cA0KWC1VbnNlbnQ6IDENCk1JTUUtVmVyc2lvbjogMS4wDQpDb250ZW50LVR5cGU6IHRl
eHQvcGxhaW47IGNoYXJzZXQ9InV0Zi04Ig0KQ29udGVudC1UcmFuc2Zlci1FbmNvZGluZzogOGJp
dA0KDQpBbiBSWCBpbnRlcnJ1cHQgZ3JvdXAgbWF5IHNlbGVjdCBtdWx0aXBsZSByZWNlaXZlIHJp
bmdzLiBUaGUgV2ktRmkgNw0KaGFuZGxlciBjdXJyZW50bHkgc2VydmljZXMgb25seSB0aGUgaGln
aGVzdCBzZXQgYml0LCBldmVuIHdoZW4gdGhlIE5BUEkNCmJ1ZGdldCBoYXMgcm9vbSBmb3Igd29y
ayBmcm9tIGFub3RoZXIgc2VsZWN0ZWQgcmluZy4gV2FsayBhbGwgc2VsZWN0ZWQNCmJpdHMgYW5k
IHJldGFpbiB0aGUgc2hhcmVkIGJ1ZGdldCBhbmQgZXhpc3RpbmcgZWFybHktZXhpdCBiZWhhdmlv
ci4NCg0KT24gYSBsb2NhbGx5IGFkYXB0ZWQgR0wtQkUzNjAwL1FDTjY0MzIsIGdyb3VwIDUgc2Vs
ZWN0cyBiaXRzIDIgYW5kIDMuIEENCmhvc3QgcmVncmVzc2lvbiBidWlsdCBmcm9tIHRoZSBhY3R1
YWwgUlggYmxvY2sgY29tcGxldGVzIDMgb2YgNiBxdWV1ZWQNCnBhY2tldHMgYmVmb3JlIHRoZSBm
aXggYW5kIDYgb2YgNiBhZnRlciBpdC4gU2luZ2xlLXJpbmcsIGVtcHR5LW1hc2sgYW5kDQp0d28t
cG9sbCBidWRnZXQgY2FzZXMgcGFzcy4gRGVzY2VuZGluZyBwcmlvcml0eSBpcyB1bmNoYW5nZWQ7
IHRoaXMgZG9lcw0Kbm90IGVzdGFibGlzaCBmYWlybmVzcyB1bmRlciBzdXN0YWluZWQgdHJhZmZp
Yy4NCg0KU2lnbmVkLW9mZi1ieTogSm9obiA8ZGVuY2l0eTdAZ21haWwuY29tPg0KDQotLS0NClJG
QyB2YWxpZGF0aW9uIGFuZCBsaW1pdHM6DQoNClNvdXJjZSBhcHBsaWNhYmlsaXR5IGFuZCB0aGUg
aG9zdCByZWdyZXNzaW9uIHdlcmUgY2hlY2tlZCBhZ2FpbnN0DQpiYWNrcG9ydHMgNy4yIHBsdXMg
dGhlIDIzMCB3aXJlbGVzcyBwYXRjaGVzIGZyb20gcGVyY2VpdmFsL29wZW53cnQtZmxpbnQzDQpj
b21taXQgMjM2NTkzMjczM2NhOGVjM2IzNDY2MjFkOWNlYzJlYjNkZjNiMmNmMy4gVGhlIG5ldyBw
YXRjaCBhcHBsaWVzDQp3aXRoIHplcm8gZnV6ei4gVGhlIHNhbWUgc291cmNlLWJsb2NrIHJlZ3Jl
c3Npb24gYW5kIGV4YWN0IHBhdGNoDQphcHBsaWNhdGlvbiBhbHNvIHBhc3MgYWdhaW5zdCBvZmZp
Y2lhbCBhdGguZ2l0IG1haW4gYXQNCjM4OGQzYzQyZThhYmExY2ZjM2M2ZDJjNTI4NzdhNDZkOGNm
NzQwZGIgKHplcm8gZnV6eikuIE5vIGZ1bGwgbW9kdWxlDQpidWlsZCBvciBoYXJkd2FyZSB0ZXN0
IHdhcyBwZXJmb3JtZWQgYWdhaW5zdCBlaXRoZXIgY3VycmVudCByZXZpc2lvbi4NCg0KSGlzdG9y
aWNhbCB0ZXN0cyBvbiBMaW51eCA2LjE4LjM5IHdpdGggbG9jYWwgYmFja3BvcnRzIDcuMi1yYzQv
UUNONjQzMg0KY2hhbmdlcyBwYXNzZWQgREhDUCwgRE5TLCAzMiBVRFAgZmxvd3MgYW5kIGFib3V0
IDE4MSBzZWNvbmRzIG9mIHRyYWZmaWMNCmFmdGVyIHJlYm9vdC4gVGhlc2UgYXJlIGJvdW5kZWQg
b2JzZXJ2YXRpb25zLCBub3QgdGhyb3VnaHB1dCBvciBsb25nLXRlcm0NCnN0YWJpbGl0eSBxdWFs
aWZpY2F0aW9uLiBUaGUgY29udHJpYnV0aW9uIHdhcyBkZXZlbG9wZWQgd2l0aCBBSSBhc3Npc3Rh
bmNlLg0KDQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTJrL3dpZmk3L2RwLmMN
CisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMmsvd2lmaTcvZHAuYw0KQEAgLTUy
LDggKzUyLDEwIEBADQogCQkJZ290byBkb25lOw0KIAl9DQogDQotCWlmIChkcC0+aHdfcGFyYW1z
LT5yaW5nX21hc2stPnJ4W2dycF9pZF0pIHsNCi0JCWkgPSBmbHMoZHAtPmh3X3BhcmFtcy0+cmlu
Z19tYXNrLT5yeFtncnBfaWRdKSAtIDE7DQorCXJpbmdfbWFzayA9IGRwLT5od19wYXJhbXMtPnJp
bmdfbWFzay0+cnhbZ3JwX2lkXTsNCisJd2hpbGUgKHJpbmdfbWFzaykgew0KKwkJaSA9IGZscyhy
aW5nX21hc2spIC0gMTsNCisJCXJpbmdfbWFzayAmPSB+QklUKGkpOw0KIAkJd29ya19kb25lID0g
YXRoMTJrX3dpZmk3X2RwX3J4X3Byb2Nlc3MoZHAsIGksIG5hcGksIGJ1ZGdldCk7DQogCQlidWRn
ZXQgLT0gd29ya19kb25lOw0KIAkJdG90X3dvcmtfZG9uZSArPSB3b3JrX2RvbmU7DQo=
--0000000000005ca053065d215c6e--
