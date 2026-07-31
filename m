Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEFC3C9888
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785486546; cv=none; b=i+OPAEjUMtgFwge6R9ZeuVKvbv/eFP69/xURHVRN8g+PlMbDbfMURFNHk964VzjUUpseZQ65Z4EIVc9RRPymxhtQErf/kKlvP03EWwL6yectKMD9buIlONLI5xDVt0+56hkW9JZvX559U2psZtxjiHDryUjBQ89XGrGXMpEB4vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785486546; c=relaxed/simple;
	bh=1GlGb33gRFeu0ldp5kUwM7ApHq+RZYDeUNAyNeeeQn8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=UJQIAdK/ukI7K3eA2KaXF2LUlZn0W5YJjuM3uIuQyNComi+goDHHPupzT2zeubx8HcCYFpxaCo6h3htdbtrI3JEpMQuUkpKdOkq7oTEa1wuzzICBYYa4Aee2Wff56QdyEQ/5WQRxFIbpgAjFONBeylG9Fw0roUckZ6qfB9VG0Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GTCrjKsc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=a8sFxIC0; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GTCrjKsc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="a8sFxIC0"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V84xOg3408224
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:29:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=xxXBjOQaVivJJP+m3lH/e6
	Blj4o5INx0Tg6Ob2u8pnA=; b=GTCrjKsc7pOSyxjYJrmw9OUnCjxz7yB5X5zfxP
	vYY+TpGyRhhM9FifAOk0I9JK3yZdry3f6DcxkIdvd9J/bSrXtQrPn2rl4m+/xBil
	OGEmsbii3e8kGItxE75rvypznqI2UDMyZVQXxY/hVT9hki28ZoazKMSpv5TD6q2Q
	nASLm8wboCOF//N8fVN6W4iq4fq5nofR05lzTBKafeSKlhR1QDDuxo80R6Eq+H75
	ZYB+8xmAGo9eOs5HmdOmYYD4ZZ//ZP3ypDGtYfvEIlyXHU6zOtEen/CoVPyBWfvW
	+2xhHw1lWfQdk5v3uHPivrC3VqGI2rdMthiG/6XLeq8smLsg==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frqvsr2qp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:29:02 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c1e6f602cso11583881cf.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 01:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785486542; x=1786091342; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xxXBjOQaVivJJP+m3lH/e6Blj4o5INx0Tg6Ob2u8pnA=;
        b=a8sFxIC0cHBuk1MlyhEXs42JWFbxWMqkvKR6grwRAtcE35QECF/pHuq35eRftVVbQg
         ssMV6BeLMH+a8SSWXfHMuWlXPFnsoCp3j8BO4iTxXgq56Zgw5LbolfxUyeCRP48/nbhr
         gQe7j22yZPDQWviQ9JNuRPjLp5NYX32ANMnI0hzcx8M7bIcygkMFIvAe4HhtuoRxkmML
         LCofJcp0afO6O5iiKjbT6X7/GV3h5obihikOOdVpTdBEPKN86Vg831PNHhQSHmUgojhE
         dHzaZFEtEqO31arwfBdanzoAh+gc4LF9gRMlQBMzfw44R5hYWlnUVdIPuBdg4SBThu3g
         WQdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785486542; x=1786091342;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=xxXBjOQaVivJJP+m3lH/e6Blj4o5INx0Tg6Ob2u8pnA=;
        b=ATygNinFMKpTfIfVR1cpP1Ufzb7/1JKQiJ8nWAUyUM0AC5BQDj96sO3xsU6IKoJXj/
         LeYgOUB4MIXpUWChvy73c7CDa8+oQkAHYoZh6RbDlsVLzzFykFRBifrcXlLWKaKA7LqI
         zSEHmT0uwuhiVTXQH18+p/yAMMEXX873IIvx5xbtpM5RB9rJ2K8tG0kKFix5yLrdwrXQ
         +P14ch24Xeai24yKHy4v90KGPi3/6H6qhuQUpz0WmAsuobWvE47uNJ804LwiEhplwZvb
         E8rpL/v5UkV4rytvbQJtHoMLTbb8Z/n5tBNFx3DefodOFUx/8ubETY52yiUVUrxZuLCf
         TqOA==
X-Forwarded-Encrypted: i=1; AHgh+Rqe1SIfan/nw0wqVQE/PkY3r3rmTZg7XgOMA+THCs3GwbGKStptrCJaVC/Xqq25OdbZevKuVA3InRYkXCMyJA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHWzd7HxZ7wrhLOWjShc3tkUE6aP0sa4l9bgPCxIUSb/be2Srb
	TI1YNkXlutfr+uPOW5pDt6twaN9I8yLrr+rs7VeseirAPBOTzSUzKoKLh7z4RaxejmdZRzqUI91
	rJZ/hv0gT85iqOYrQ0q/OC8P4BxiZCdEJdMd60Yr/IJDpHxfel+MU2uIzHEZs7W79tC7mng==
X-Gm-Gg: AR+sD12feD9hBQ8OoAPM1/Hp2n4QLynsV//x10s1vhvdSNwnyFs6E6Ruj8upL6LkVpH
	cdRbGhoJjC7OkqUXzyvH7RWDsTj+WaQ8p4nhOj6faKV+qBUJxHN8DYhPLLuuTT5YTzdxxPkGLe1
	QzG9wXAq4lhSS6QuJWF0k2MKd8B5lEg0eNWeiBeQVBKjpi2UfYYBDqbVllN6p67eEOpv5jXW7+N
	GdodFSk0A2M/JxSYLLmf+1AzSUiCRFCH5gx7Ur4TViI4/NNor5zNbStJogDCBZghclAJ/aMr2yL
	00SzFZOkKrcSk31XoN3UKEyoQ9VmNZ+vAQ4vSV1dHs3UiTr1fmGjr/uCdSx/OO150NSkd70iYir
	JBSNr/U6qvYw+FWXVLValIkR/bSy+cQ==
X-Received: by 2002:a05:622a:6093:b0:51b:fd82:22dd with SMTP id d75a77b69052e-52b4af3e60bmr13993101cf.15.1785486541591;
        Fri, 31 Jul 2026 01:29:01 -0700 (PDT)
X-Received: by 2002:a05:622a:6093:b0:51b:fd82:22dd with SMTP id d75a77b69052e-52b4af3e60bmr13992841cf.15.1785486541160;
        Fri, 31 Jul 2026 01:29:01 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:40fa:e8e6:4785:ce70])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd3c90f52sm66412266b.16.2026.07.31.01.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 01:29:00 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 10:28:50 +0200
Subject: [PATCH v2] power: sequencing: rename pwrseq_power_on/off() to
 pwrseq_enable/disable()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-pwrseq-vote-rename-v2-1-480357946e00@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAMFcbGoC/32NTQ6CMBCFr0Jm7ZC2xlZdcQ/DopZRmgiFDlYN6
 d2tHMDNS76X97MCU/TEcK5WiJQ8+zAWULsKXG/HO6HvCoMSSgujDE6vyDRjCgthpNEOhFfjOiX
 FXml9hFKcIt38exu9tIV7z0uIn+0jyZ/7dy5JlGhL4mSJrNOHJjDX89M+XBiGugi0OecvQ5Id4
 bsAAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=11617;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=1GlGb33gRFeu0ldp5kUwM7ApHq+RZYDeUNAyNeeeQn8=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqbFzFJt6O8wisou3BKsioXgAk/mjF1g90Iazw4
 Q+GK32nk4WJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCamxcxQAKCRAFnS7L/zaE
 w5KiD/9uG0pyhUUSXNyne3ZBbn/ozYp9Z/b8T3f++gwk55/CBAUPOmX2LtavoIZR4mMmKoIubHQ
 CgOycHiDpbS8ci6fYmDKLOQAE9NsVYGIn94H6/bCf/FjcCwHgf5qsoCSadZSpPkSexsmLTgmNn2
 37xmxDx1e6dmukUv3P0INHQPENmbUC2vv3k9SEGdXfiT61tI35vJpW/S5wbTzFwU8YMeW/rFz4b
 I7GafpAu+h2W39O3kaFwzNSiDQ0JG7dFUWR/HqA0zxzKaf1k2LgscpgJ7bFP5P3Cw9Bmj1IJ0R2
 Hi2etbbfqkMkXtIwB0E17PCl77rDRYvBPSudQ2wamrrNNCEy6Qjclz/HJl8MXzXUeQPGVIGQ9jZ
 M0IDAV2EVtfXqecbzeghxirJ6F3VX3ogfRoITkcPyx+PBTYbuCDAZapLb8rdk+AlE3jSnjpGXtC
 ln3DCt10POHURDM5TAUlnSta0cHg01EDOqzu+JbtT/JexL+ZTeHUpe7a26j8y6UC5Ht0NnqW0bs
 OFZeV5fgIa5QgWJROY77j3rgqUSDOEMycs+b7kXPS0WskKCMkZ5ntraOM63MbzcFsJ7hdWTzMGm
 QHCctpTrQZeHX1/x/CrVjqgwC8J1UeBkVUvpQnbVti2h3uQtq+5IXhc05rdo/GdrTibeOfP/BAx
 mGO/h5vwIDjrlWw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA2MCBTYWx0ZWRfXz4izupkErE8B
 KQHCEb4Mbm1LHliaK3+Q9N/5gwmoK0M/m0h8OSd0OBHejyAfZJYZ+UnPY7iSC/yzr/e57Eqy4S4
 RpRbKGRM78FDfgOfNd28ZjdliRJcH0c=
X-Authority-Analysis: v=2.4 cv=TN51jVla c=1 sm=1 tr=0 ts=6a6c5cce cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=1XWaLZrsAAAA:8
 a=RTdnRIbMq3CNlSfCOOQA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-ORIG-GUID: 575v_51DhI_VNqYS7Dz7lT10LSO37VGp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA2MCBTYWx0ZWRfX5rcNM9nAse+W
 X/L2gg/47bUlU1RzxxMDvuJ78nYXwg/hAuIk3/0yqQ5tPLenm6V1wkRiTIEHsJMsV0IzbGLfFAH
 q9GJ9at5alCnO1k13Mg/JCiqJMMfuW7wrgNN/GW9Z/rMwCSARIv503LtseJtzy+j3weVRdp3xno
 0Hg1UqFyphB7Pn75gaLR7KEW9iGCYVcpHQoSLCuH+cRU6WtmMioXDBO/gxw40xOu2IfCgqITWEN
 c10nAMT0dCeJ5d9ogKWqW5n9h37VRkIHSCSJjhF8S3TK46vaN4edbR1FFA0jWurJLwBcTe9oOPA
 k04emCC0aC46QqL+NvMk8mNR2nMLtzWE5XZ+SYT7JTELjMYvtxya90ppVB04En8vTImwpAuBPgX
 b/FSnTeK8RFw5tMEmes7J+7h4e8RqInWJWI2pypdrBPll0Jtgsbf4XM1UKnIqARNSnl8k1rSmYw
 nW0SRMSa3BV2Ijd+kBQ==
X-Proofpoint-GUID: 575v_51DhI_VNqYS7Dz7lT10LSO37VGp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607310060

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
index ad18b2326b689a41471216f3889480b11768ca82..0c315ab1138b02540fae60b39928c580027c0f7c 100644
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
+pwrseq_disble(). Note that there is no guarantee that pwrseq_disble()
 will have any effect as there may be multiple users of the underlying resources
 who may keep them active.
 
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 345f602e9ce233a0934a73a85d1e7c17c4f3210d..e713fc06b73402ae3d57794ed0870df8394a796a 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2259,7 +2259,7 @@ static void qca_power_off(struct hci_uart *hu)
 	}
 
 	if (power && power->pwrseq) {
-		pwrseq_power_off(power->pwrseq);
+		pwrseq_disble(power->pwrseq);
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
index a71d5b35601e7b996428312028a4c0542a5b1350..031fad8adf4f4843e852000d3d6ba45d0e4b0aeb 100644
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
+	return pwrseq_disble(pvr_dev->pwrseq);
 }
 
 const struct pvr_power_sequence_ops pvr_power_sequence_ops_pwrseq = {
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 3106502275781d32d17a45a661362206144df6b3..d7e23971fe1da99f6b5f7559d62d04e2044d8950 100644
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
+	pwrseq_disble(ar_snoc->pwrseq);
 
 	return ret;
 }
@@ -1060,7 +1060,7 @@ static int ath10k_hw_power_off(struct ath10k *ar)
 	ret_vreg = regulator_bulk_disable(ar_snoc->num_vregs, ar_snoc->vregs);
 
 	if (ar_snoc->pwrseq)
-		ret_seq = pwrseq_power_off(ar_snoc->pwrseq);
+		ret_seq = pwrseq_disble(ar_snoc->pwrseq);
 
 	return ret_vreg ? : ret_seq;
 }
diff --git a/drivers/pci/pwrctrl/generic.c b/drivers/pci/pwrctrl/generic.c
index a7e599d841e6289db161b19a93ba5a61d9e0ab1c..d366883355173eac1a2631b73e5e041666ac23ad 100644
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
+		pwrseq_disble(slot->pwrseq);
 		return 0;
 	}
 
diff --git a/drivers/pci/pwrctrl/pci-pwrctrl-pwrseq.c b/drivers/pci/pwrctrl/pci-pwrctrl-pwrseq.c
index a308bf4b5fc01d23b75db4cd396201c3ba3fe695..2a6f46f6e2012dd985b657c97c85879ba13b5133 100644
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
+	return pwrseq_disble(pwrseq->pwrseq);
 }
 
 static int pwrseq_pwrctrl_probe(struct platform_device *pdev)
diff --git a/drivers/power/sequencing/core.c b/drivers/power/sequencing/core.c
index 02f42da915985339d3de507fc36dd158b0035a99..34d5c0af6f37bdbfa9d656d95795d38cc7e38762 100644
--- a/drivers/power/sequencing/core.c
+++ b/drivers/power/sequencing/core.c
@@ -708,7 +708,7 @@ void pwrseq_put(struct pwrseq_desc *desc)
 	pwrseq = desc->pwrseq;
 
 	if (desc->powered_on)
-		pwrseq_power_off(desc);
+		pwrseq_disble(desc);
 
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
+ * pwrseq_disble() - Issue a power-off request on behalf of the consumer
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
+int pwrseq_disble(struct pwrseq_desc *desc)
 {
 	struct pwrseq_device *pwrseq;
 	struct pwrseq_unit *unit;
@@ -966,7 +966,7 @@ int pwrseq_power_off(struct pwrseq_desc *desc)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(pwrseq_power_off);
+EXPORT_SYMBOL_GPL(pwrseq_disble);
 
 /**
  * pwrseq_to_device() - Get the pwrseq device pointer from a descriptor.
diff --git a/include/linux/pwrseq/consumer.h b/include/linux/pwrseq/consumer.h
index 3c907c9e1885dc2958043a9a733fbe20bdf95f6e..5e94b0b9c38b036fc40e3e2c8c6e1020d0d0bb6e 100644
--- a/include/linux/pwrseq/consumer.h
+++ b/include/linux/pwrseq/consumer.h
@@ -20,8 +20,8 @@ void pwrseq_put(struct pwrseq_desc *desc);
 struct pwrseq_desc * __must_check
 devm_pwrseq_get(struct device *dev, const char *target);
 
-int pwrseq_power_on(struct pwrseq_desc *desc);
-int pwrseq_power_off(struct pwrseq_desc *desc);
+int pwrseq_enable(struct pwrseq_desc *desc);
+int pwrseq_disble(struct pwrseq_desc *desc);
 
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
+static inline int pwrseq_disble(struct pwrseq_desc *desc)
 {
 	return -ENOSYS;
 }

---
base-commit: 95d6a9ccef99117115e41e9adb271243bd5e985b
change-id: 20260727-pwrseq-vote-rename-b7cd21032668

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

