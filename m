Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E2D2D9EED
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 13:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785505353; cv=none; b=tZ9P80bmJwkAPcoc05TfK6NLvXjdHFOB9sIsNlwwILZePUwTPaxKgletXjAvY+wmbrEFX3E+l4hYCB0ctgA4ZSepIoNv+ytM2d6X5vZqwMacHjf93aSj85//h5rlvAP6q5GUOcYkL74fwF7dGTtYi7W3tHua/6Z8UjOXt3YeN3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785505353; c=relaxed/simple;
	bh=/ZtYnblEv5u9xlI130waUKIQSQ7Ho1KTod+WjiROOSo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ibiyHbcyzgUiIaOYnxoreCQUc2Eftf+zHZgDY3EkbwFjLtwUFzq8WIDl+8IV1+myFYOxT8DnCWQG0MgRB2cpXhlwmqdO8AGUqU6tFObh/bUBysd+Plr7AxZH7n+3eOfMcWhoCe/1NToTlA0MIIg7DhkwnDsZ/qLhkLLyxihxjJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kokLOxeQ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QPRBbE6V; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kokLOxeQ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QPRBbE6V"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VBjdS64054639
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 13:42:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=I7QdW2PBreeH2I/q/W9dkz
	OrQKYFPLU3+DU1c9bD4Hw=; b=kokLOxeQr8liutJQR+sVROVyP9mN89ywBdMOpB
	urCHbNngljt5xMxE9DKGuBRhjFMW6PPNDeNaUjczbJ3JO1l2LKvIBu/hG8a7yGfX
	ZCozgLofknV/JfjRFdgZDAcffJ/al08D+o7PPnY/ZKe302nBXaCHM3VVhuwWkP78
	t0OIp6RsA2hBUQrKsugIlBARcPkLjlGF3jCwGNfICqt12H20LwybIDew6XxAAyiu
	jkz+nAC6c0MPCVlUFjIsxQZz5piYWTJS/fstrMvoh9Ko7EFSLCEQllrVA9MVrfao
	2ZpT9r2dTw4CqC2Qob8JOZspicyZV85hN4WhUYwPFGN1PfDQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fru480d6t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 13:42:30 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c1e6f602cso15758911cf.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 06:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785505350; x=1786110150; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=I7QdW2PBreeH2I/q/W9dkzOrQKYFPLU3+DU1c9bD4Hw=;
        b=QPRBbE6VfV+ldvg7Z9/j4L2wOKuG5voFCybXCH1XitT3R7dzpTsEZ4s1abP1cLpjtA
         ZDFxOQA7UJTEJ6+fC52NSpwPcU8GJCS375k/sH3JeG0FwwIP/XKqOEUC/R6i56Pk0cl2
         /QzJ+6LWWIvbjEg4nLrHTQ6kntktu288RY7e/kbCH5uiBLmoo9HeUeq5JMTDPLdNmdZ1
         LQrBWkDhD+5cw2jN0miDGeCI4GgFbXUB1S+vgvdRmJl7vY9vmj8u7I7e5ehexyMVKRRo
         k+M/3MTBa3HGGXMNN/I/ZuT51c6iH979uxcHNxjawfPgk6gp82k2JUB5ZtHUqiDJKRH9
         j3Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785505350; x=1786110150;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=I7QdW2PBreeH2I/q/W9dkzOrQKYFPLU3+DU1c9bD4Hw=;
        b=kG7Cj37Kx+cS+BbeYrRC9yIbQeymFA+c6Q+UOwmY4OijopWeRLd9n8VNaLsHaLcoHO
         xzz0KnJRd3Hfo5/MpwJd/LGdvS038+BabgKBMREPZNHFg1JMMq7o/P/FbwS6ys1OoY4u
         AefJzN3ttHLpe01oOpE2HmUoK78y25tCWsWPceQC/HX+KAqgMjbIjrkqlXBxiimJnfu4
         SqYKT9RBwDJhC4lerNuWdTUewkrKvuLYM5W4K9jrB9nCE1Qw4aZKVMr8W98kYXQPWkuP
         ++rONcK/XLGogLbuXWNeD4Wbx4z1jwkWRiA4ygtfxNDiWkXqIcaWhCRCFuuSxFsDEyF8
         e0UQ==
X-Forwarded-Encrypted: i=1; AHgh+RpvRRICaxfDHzpWJsgsnFfw6g7X7dY79MVLScFD7+PMLvRW+B5QtwYzDGjQnpkkQ7BuLWu97XuPOWt9/QO4eA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyj3EfayiaBFgIZk2O1XpfJQCOPPP4wajH7hDny6ziSIoToYeU7
	CdXl5dnrYIeAfFySyAGOp4KsL8pglAIxGXhFvAEEpvxTsXhhNXrlMkeGNq3jbreCvoa20Hmlfd/
	gm42ZwEkNEuKqr5oPCKTQPGk2rfmbkfwYIypoM+rZHwSp34n4y6+dTK4kRsuDzsYTM4Otgg==
X-Gm-Gg: AR+sD13ljsMTrcOPt0z0ZAT3ZLWiCLngq663VW2J+u2Q9qkPngNDilN27k8Ugvx8BFD
	s8j/9Cqp65TKT95tBLyz4odspdPr6qf3DOjbkZkOcGZgAVu0/SWC+F8Q/qtjPItXgl2IScO8exM
	gMMjO7W3w/cxGQkLGnl//FvjXgeobpVjAhVIUzJXiHxJGbaPzcBXKxtIDYDqJXlGozp0cMhDVGr
	tEeGMy//8cMUrPq2O6a9u8zdTWD8GWnL2Ul516PlWFkrvUjgOdEEQVqwjsZKd8eKE+z2pdTmYMj
	n8pFam/q+LudaMJ9M71ZfJrb38VdF/m6HW4UTXKRzSHfpKQ+eaubmRwE7Oa46qm71zwveDbJswG
	STlxGOgLuOKnYmOsPfTj7htmDJoADUA==
X-Received: by 2002:a05:622a:4c8c:b0:51c:257c:8166 with SMTP id d75a77b69052e-52b567915d7mr2006931cf.33.1785505349302;
        Fri, 31 Jul 2026 06:42:29 -0700 (PDT)
X-Received: by 2002:a05:622a:4c8c:b0:51c:257c:8166 with SMTP id d75a77b69052e-52b567915d7mr2005921cf.33.1785505348617;
        Fri, 31 Jul 2026 06:42:28 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:40fa:e8e6:4785:ce70])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd3c5b4d4sm170638366b.3.2026.07.31.06.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 06:42:27 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 15:42:18 +0200
Subject: [PATCH v3] power: sequencing: rename pwrseq_power_on/off() to
 pwrseq_enable/disable()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-pwrseq-vote-rename-v3-1-44e60b8be053@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIADmmbGoC/33NQQ6CMBAF0KuQri1pp9CCK+9hXNQyShOh0GLVE
 O5uYeWCuJnkT/68mUlAbzGQYzYTj9EG6/oUxCEjptX9HaltUibAQDIFig4vH3Ck0U1IPfa6Q3p
 VpgHOBEhZkXQ4eLzZ94aeLym3NkzOf7Yfka/bv1zklFOdGrVG1EaWJxdCPj71w7iuy9MgqxrhR
 xJ8V4IkFRUTpaoLiYztSMuyfAGchA57BQEAAA==
X-Change-ID: 20260727-pwrseq-vote-rename-b7cd21032668
To: Bartosz Golaszewski <brgl@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alessio Belle <alessio.belle@imgtec.com>,
        Luigi Santivetti <luigi.santivetti@imgtec.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Jeff Johnson <jjohnson@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Chen-Yu Tsai <wens@kernel.org>,
        Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, imagination@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-pci@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=11797;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=/ZtYnblEv5u9xlI130waUKIQSQ7Ho1KTod+WjiROOSo=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqbKY9BLAKPCKKdAtGKsF/O1XETtWdpusNUE+kz
 k3xKaVeETeJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCamymPQAKCRAFnS7L/zaE
 w77CEACsyXT5/yMxHu3ndloSlpevSE+Xmz6RAu8QU74Y5sEYJSkVdMTfKAB07P6C3AXxrhXz1SO
 hAfDA26nBMR4HY8+Dbts3letQqVtiYaE1WYS6fzOj/lGy2E5FpT0TFLRlTrKAyQgCZBea7IOg6u
 b/xjl2grrnzOE73eKwZF2PDXi3kn2nLgCmykKxnLNpi9iNzp4TUL2BSz4T/cpsC0Bz/pUtYrXT1
 PTjFx7uZnUX83pxElnPGBDy8eX/1z3JhwkiTG99mcyqL44w6iFJh94A4Zu2436xDPG1NCZMtU5t
 mEa5hNLnnEGLv4whY+CTxMCv0pHuNVjT5ko1hdokSkv8EHPg1zvdBmRPFh8lK436UVN4d3RW73L
 1j352tkrJr98H+76xbO2Fpq0Pf+bjmU3Wki/pi0dWtw2mxASSxPPVNfZ0yLB0OIvwAglTGgTPYu
 UuPeuOHRJlrQg08cTreWJY2gdifIGumeRPprkwbDsHpWz8kFLbN/7hyazrw6ja+HZjLUeWq/Fdd
 g0A+he10ZFP9oO1Ep79ujgyAd2eP0PSHgrtQ2DCRZYdx0BR8D16rDGOT2bUfP8QHXua+856Gd50
 CVvv3GZ3gtF2vrFIqbmTf0nxqzf9F/Wl6Cue/AyixiYdka/DBV4hI3D4XaoTS9jO0jCFkVbvxxr
 6GFlCm9Og5+HPFg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=IJsyzAvG c=1 sm=1 tr=0 ts=6a6ca646 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=1XWaLZrsAAAA:8
 a=RTdnRIbMq3CNlSfCOOQA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDEwNCBTYWx0ZWRfX9nCR8FHi6s4S
 /mZab2giN2re0Z7640q/jRu+WblGIoUAMIs9Hy0RyxWdioceJ9WSkECcWpA0u0NhkxKkpi0wK8L
 Tl+mwN+pNuSRYWBucI6KBH9VW5ed19Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDEwNCBTYWx0ZWRfX/4cHOCGgNTQ0
 MAACVJwfut0WV7Z92H/U61nRHVJYtT9IJgbkzjQPU8ZLCHnQ/yxOPtP6iayLIaccybXg8XBv3ze
 kQKio9avUg0Bj/3eDmIeCRZVnjitz0Ktu8SubxMHtQPRIoJHlI3PvfsYWEUtLJQL3RBee4d2PGj
 l0L4rgYsiEptqzDJkDEcm/JFQxia8PSjI16mzlIM16a20vBepVMO21SX7rZM7EWtH0adFA++9ho
 k3zAOZjEoEPpSbQOu1hdiiyahb7tyvlpnWvZpisSOarCo98BUXbxvOpF6ujtCafx84F0EJ4Vbsr
 BP8ztb/Hi1eALwBx5v/GM9XofBGy65FaUg9SLlv+I7hY48vRnmEJRNWdMcldpj7oTcdUWMXzfTF
 cYNj9KofzaJHXbY7NtPCWdL9uCoDmAyVrLjj3qiOnP7n/UH1c+K3lx/h8FuZ958tMlvAHoTeLvB
 n+8U1/v68VyemsSQnNg==
X-Proofpoint-GUID: Z58KxXsa4NQJrpde-N3aRo8HqQGyzT96
X-Proofpoint-ORIG-GUID: Z58KxXsa4NQJrpde-N3aRo8HqQGyzT96
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_04,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310104

The way power sequencing works means that a call to pwrseq_power_on()
does not necessarily result in the pwrseq target being powered-on at
that time: it may have already been powered on before. Similarly: a call
to pwrseq_power_off() does not have to result in an actual powering off
of resources: there may still be other users that requested a power-on
before.

We will also introduce the concept of "non-controllable" pwrseq targets
soon which further increases the disconnect between the naming
convention and the actual semantics.

What consumers of pwrseq descriptors actually do is: they *vote* for a
powering on of a given target or retract that vote. These operations
could be called get/put in line with runtime PM but this could become
confusing since we already provide pwrseq_get/put() for a different
purpose. pwrseq_vote_on/off() also have been rejected as unusual in
the tree.

Change the name of the two functions to pwrseq_enable/disable() which
better reflects their purpose and semantics and also mirrors other
enable-counted resources like regulators and clocks. No functional change
intended.

If at any point users need to know *when* the exact power event happens,
we can provide that information in the form of a notifier.

Acked-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
I've floated the idea to rename the two pwrseq functions from "power
on/off" to "vote on/off". I've sent a patch but the overwhelming
consensus seem to be that enable/disable naming is preferred.

I'm doing it in a single commit that should go through the pwrseq tree
with Acks from subsystem maintainers.

[1] https://lore.kernel.org/all/CAMRc=Mefxn81d0VUwmQgwFtffkL1=Er_1VQZCbC1Sa-Qph4t1w@mail.gmail.com/
---
Changes in v3:
- Fix type: pwrseq_disble -> pwrseq_disable
- Link to v2: https://patch.msgid.link/20260731-pwrseq-vote-rename-v2-1-480357946e00@oss.qualcomm.com

Changes in v2:
- Change the naming convention to enable/disable
- Link to v1: https://patch.msgid.link/20260727-pwrseq-vote-rename-v1-1-a2029aeeac65@oss.qualcomm.com
---
 Documentation/driver-api/pwrseq.rst      |  4 ++--
 drivers/bluetooth/hci_qca.c              |  4 ++--
 drivers/gpu/drm/imagination/pvr_power.c  |  4 ++--
 drivers/net/wireless/ath/ath10k/snoc.c   |  6 +++---
 drivers/pci/pwrctrl/generic.c            |  4 ++--
 drivers/pci/pwrctrl/pci-pwrctrl-pwrseq.c |  4 ++--
 drivers/power/sequencing/core.c          | 16 ++++++++--------
 include/linux/pwrseq/consumer.h          |  8 ++++----
 8 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/Documentation/driver-api/pwrseq.rst b/Documentation/driver-api/pwrseq.rst
index ad18b2326b689a41471216f3889480b11768ca82..e1056d1418451b0feda6567bab9eec1cbff682fb 100644
--- a/Documentation/driver-api/pwrseq.rst
+++ b/Documentation/driver-api/pwrseq.rst
@@ -50,9 +50,9 @@ Consumer interface
 The consumer API is aimed to be as simple as possible. The driver interested in
 getting a descriptor from the power sequencer should call pwrseq_get() and
 specify the name of the target it wants to reach in the sequence after calling
-pwrseq_power_up(). The descriptor can be released by calling pwrseq_put() and
+pwrseq_enable(). The descriptor can be released by calling pwrseq_put() and
 the consumer can request the powering down of its target with
-pwrseq_power_off(). Note that there is no guarantee that pwrseq_power_off()
+pwrseq_disable(). Note that there is no guarantee that pwrseq_disable()
 will have any effect as there may be multiple users of the underlying resources
 who may keep them active.
 
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 345f602e9ce233a0934a73a85d1e7c17c4f3210d..faa964735adb17a05f2a8fac16f553b37b96020b 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2259,7 +2259,7 @@ static void qca_power_off(struct hci_uart *hu)
 	}
 
 	if (power && power->pwrseq) {
-		pwrseq_power_off(power->pwrseq);
+		pwrseq_disable(power->pwrseq);
 		set_bit(QCA_BT_OFF, &qca->flags);
 		return;
         }
@@ -2319,7 +2319,7 @@ static int qca_regulator_enable(struct qca_serdev *qcadev)
 	int ret;
 
 	if (power->pwrseq)
-		return pwrseq_power_on(power->pwrseq);
+		return pwrseq_enable(power->pwrseq);
 
 	/* Already enabled */
 	if (power->vregs_on)
diff --git a/drivers/gpu/drm/imagination/pvr_power.c b/drivers/gpu/drm/imagination/pvr_power.c
index a71d5b35601e7b996428312028a4c0542a5b1350..eb4b6ecdf4f4d09d96d17d0d53ec5cb876b21b50 100644
--- a/drivers/gpu/drm/imagination/pvr_power.c
+++ b/drivers/gpu/drm/imagination/pvr_power.c
@@ -352,12 +352,12 @@ static int pvr_power_init_pwrseq(struct pvr_device *pvr_dev)
 
 static int pvr_power_on_sequence_pwrseq(struct pvr_device *pvr_dev)
 {
-	return pwrseq_power_on(pvr_dev->pwrseq);
+	return pwrseq_enable(pvr_dev->pwrseq);
 }
 
 static int pvr_power_off_sequence_pwrseq(struct pvr_device *pvr_dev)
 {
-	return pwrseq_power_off(pvr_dev->pwrseq);
+	return pwrseq_disable(pvr_dev->pwrseq);
 }
 
 const struct pvr_power_sequence_ops pvr_power_sequence_ops_pwrseq = {
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 3106502275781d32d17a45a661362206144df6b3..f28fed89cc28b45d72a9814be38d19e2cdf96943 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1025,7 +1025,7 @@ static int ath10k_hw_power_on(struct ath10k *ar)
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "soc power on\n");
 
-	ret = pwrseq_power_on(ar_snoc->pwrseq);
+	ret = pwrseq_enable(ar_snoc->pwrseq);
 	if (ret)
 		return ret;
 
@@ -1042,7 +1042,7 @@ static int ath10k_hw_power_on(struct ath10k *ar)
 vreg_off:
 	regulator_bulk_disable(ar_snoc->num_vregs, ar_snoc->vregs);
 pwrseq_off:
-	pwrseq_power_off(ar_snoc->pwrseq);
+	pwrseq_disable(ar_snoc->pwrseq);
 
 	return ret;
 }
@@ -1060,7 +1060,7 @@ static int ath10k_hw_power_off(struct ath10k *ar)
 	ret_vreg = regulator_bulk_disable(ar_snoc->num_vregs, ar_snoc->vregs);
 
 	if (ar_snoc->pwrseq)
-		ret_seq = pwrseq_power_off(ar_snoc->pwrseq);
+		ret_seq = pwrseq_disable(ar_snoc->pwrseq);
 
 	return ret_vreg ? : ret_seq;
 }
diff --git a/drivers/pci/pwrctrl/generic.c b/drivers/pci/pwrctrl/generic.c
index a7e599d841e6289db161b19a93ba5a61d9e0ab1c..d56171e0ee244691c3bdb0a72b81c65556a8081f 100644
--- a/drivers/pci/pwrctrl/generic.c
+++ b/drivers/pci/pwrctrl/generic.c
@@ -29,7 +29,7 @@ static int slot_pwrctrl_power_on(struct pci_pwrctrl *pwrctrl)
 	int ret;
 
 	if (slot->pwrseq) {
-		pwrseq_power_on(slot->pwrseq);
+		pwrseq_enable(slot->pwrseq);
 		return 0;
 	}
 
@@ -48,7 +48,7 @@ static int slot_pwrctrl_power_off(struct pci_pwrctrl *pwrctrl)
 						struct slot_pwrctrl, pwrctrl);
 
 	if (slot->pwrseq) {
-		pwrseq_power_off(slot->pwrseq);
+		pwrseq_disable(slot->pwrseq);
 		return 0;
 	}
 
diff --git a/drivers/pci/pwrctrl/pci-pwrctrl-pwrseq.c b/drivers/pci/pwrctrl/pci-pwrctrl-pwrseq.c
index a308bf4b5fc01d23b75db4cd396201c3ba3fe695..c5ced87944b6ca3dc642692311ff504a650acec7 100644
--- a/drivers/pci/pwrctrl/pci-pwrctrl-pwrseq.c
+++ b/drivers/pci/pwrctrl/pci-pwrctrl-pwrseq.c
@@ -56,7 +56,7 @@ static int pwrseq_pwrctrl_power_on(struct pci_pwrctrl *pwrctrl)
 	struct pwrseq_pwrctrl *pwrseq = container_of(pwrctrl,
 					   struct pwrseq_pwrctrl, pwrctrl);
 
-	return pwrseq_power_on(pwrseq->pwrseq);
+	return pwrseq_enable(pwrseq->pwrseq);
 }
 
 static int pwrseq_pwrctrl_power_off(struct pci_pwrctrl *pwrctrl)
@@ -64,7 +64,7 @@ static int pwrseq_pwrctrl_power_off(struct pci_pwrctrl *pwrctrl)
 	struct pwrseq_pwrctrl *pwrseq = container_of(pwrctrl,
 					   struct pwrseq_pwrctrl, pwrctrl);
 
-	return pwrseq_power_off(pwrseq->pwrseq);
+	return pwrseq_disable(pwrseq->pwrseq);
 }
 
 static int pwrseq_pwrctrl_probe(struct platform_device *pdev)
diff --git a/drivers/power/sequencing/core.c b/drivers/power/sequencing/core.c
index 02f42da915985339d3de507fc36dd158b0035a99..721e888b658d1f254513e126bb72f2d0487a8383 100644
--- a/drivers/power/sequencing/core.c
+++ b/drivers/power/sequencing/core.c
@@ -708,7 +708,7 @@ void pwrseq_put(struct pwrseq_desc *desc)
 	pwrseq = desc->pwrseq;
 
 	if (desc->powered_on)
-		pwrseq_power_off(desc);
+		pwrseq_disable(desc);
 
 	kfree(desc);
 	module_put(pwrseq->owner);
@@ -874,7 +874,7 @@ static int pwrseq_unit_disable(struct pwrseq_device *pwrseq,
 }
 
 /**
- * pwrseq_power_on() - Issue a power-on request on behalf of the consumer
+ * pwrseq_enable() - Issue a power-on request on behalf of the consumer
  *                     device.
  * @desc: Descriptor referencing the power sequencer.
  *
@@ -887,7 +887,7 @@ static int pwrseq_unit_disable(struct pwrseq_device *pwrseq,
  * Returns:
  * 0 on success, negative error number on failure.
  */
-int pwrseq_power_on(struct pwrseq_desc *desc)
+int pwrseq_enable(struct pwrseq_desc *desc)
 {
 	struct pwrseq_device *pwrseq;
 	struct pwrseq_target *target;
@@ -925,14 +925,14 @@ int pwrseq_power_on(struct pwrseq_desc *desc)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(pwrseq_power_on);
+EXPORT_SYMBOL_GPL(pwrseq_enable);
 
 /**
- * pwrseq_power_off() - Issue a power-off request on behalf of the consumer
+ * pwrseq_disable() - Issue a power-off request on behalf of the consumer
  *                      device.
  * @desc: Descriptor referencing the power sequencer.
  *
- * This undoes the effects of pwrseq_power_on(). It issues a power-off request
+ * This undoes the effects of pwrseq_enable(). It issues a power-off request
  * on behalf of the consumer and when the last remaining user does so, the
  * power-down sequence will be started. If one is in progress, the function
  * will block until it's complete and then return.
@@ -940,7 +940,7 @@ EXPORT_SYMBOL_GPL(pwrseq_power_on);
  * Returns:
  * 0 on success, negative error number on failure.
  */
-int pwrseq_power_off(struct pwrseq_desc *desc)
+int pwrseq_disable(struct pwrseq_desc *desc)
 {
 	struct pwrseq_device *pwrseq;
 	struct pwrseq_unit *unit;
@@ -966,7 +966,7 @@ int pwrseq_power_off(struct pwrseq_desc *desc)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(pwrseq_power_off);
+EXPORT_SYMBOL_GPL(pwrseq_disable);
 
 /**
  * pwrseq_to_device() - Get the pwrseq device pointer from a descriptor.
diff --git a/include/linux/pwrseq/consumer.h b/include/linux/pwrseq/consumer.h
index 3c907c9e1885dc2958043a9a733fbe20bdf95f6e..16fad5f3e3ab563110598f733e4a6c10a7b13f2d 100644
--- a/include/linux/pwrseq/consumer.h
+++ b/include/linux/pwrseq/consumer.h
@@ -20,8 +20,8 @@ void pwrseq_put(struct pwrseq_desc *desc);
 struct pwrseq_desc * __must_check
 devm_pwrseq_get(struct device *dev, const char *target);
 
-int pwrseq_power_on(struct pwrseq_desc *desc);
-int pwrseq_power_off(struct pwrseq_desc *desc);
+int pwrseq_enable(struct pwrseq_desc *desc);
+int pwrseq_disable(struct pwrseq_desc *desc);
 
 struct device *pwrseq_to_device(struct pwrseq_desc *desc);
 
@@ -43,12 +43,12 @@ devm_pwrseq_get(struct device *dev, const char *target)
 	return ERR_PTR(-ENOSYS);
 }
 
-static inline int pwrseq_power_on(struct pwrseq_desc *desc)
+static inline int pwrseq_enable(struct pwrseq_desc *desc)
 {
 	return -ENOSYS;
 }
 
-static inline int pwrseq_power_off(struct pwrseq_desc *desc)
+static inline int pwrseq_disable(struct pwrseq_desc *desc)
 {
 	return -ENOSYS;
 }

---
base-commit: 95d6a9ccef99117115e41e9adb271243bd5e985b
change-id: 20260727-pwrseq-vote-rename-b7cd21032668

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

