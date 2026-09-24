Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD883D7D75
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790217696; cv=none; b=pQJKFpFVP7f7Pb84+zmsBuVsX20IXumySdVGilOhcpDLJAA+k8FfxCIKk1x9K71zYWFfCnrKHeCIDIvA5QpsYJ4rP+h5kNraADaXLqDzaLoex5RYtXKNiWcrUbtL7nGDcLsECW2RHiVJ6Vdhe3kSVcn5Xp8QfI8XXZvARUN0I80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790217696; c=relaxed/simple;
	bh=/9w5q2UZtiN63unZO6x+fdZXRWbclI5wkZJUvm7FhLI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=gEk+ATkKGo0Na8CTeErsK/bsIDUjniGeeLdPfwT3q6kVt9gHX4TmRlgJr8GZz5luGMPLaiwsB3K88vbyay54V0IP3IdUKq3aRF7lWxU8LLkr3INNBN5tCejhiD173VYGpMhX/nyhXMJqrI6VIzR8MjU5XaPWHw7xY14HYtnWiwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iEcHCMxb; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Guor+u7i; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iEcHCMxb";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Guor+u7i"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O2KBNn854083
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:41:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=0nzk71Z/a/OJRy4Wvd2k18
	mEehJYeU7+sulfI7+0Deg=; b=iEcHCMxbhHgvLAejtHniySHDHRmIym1RJeyQpr
	h3XI/fwG959CHHBSpQTdQ01zCFZEhuYYJbjSWTMofv8AVZlRtoe81ZO5riqmaBK8
	/9GtJi6mqT0vD96tFQQbqgueJETRex6LNe130DHYNtkpwxfP1nWzOYxOHC+TPNyO
	ZMYZoAHwWulgrHwiPaqCs4F3zOFN1gy/4MRfYROGUUEeCygQwlBBsx8nlwF5TJOt
	meEmHyMrd7igzxeRZwoKCogYUqul7q+8XG9d1phqFhDFjFPSd5Z0019eGlOZnZuN
	LNgnc2DeWOEr3nHjSxP76crULnMPW3CrwlU1F41hBM4Dm+Xw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvhsb28wt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:41:33 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30c0d568830so2908952eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 19:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790217692; x=1790822492; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0nzk71Z/a/OJRy4Wvd2k18mEehJYeU7+sulfI7+0Deg=;
        b=Guor+u7iz5okPrNboVMQpThF9ig6DpZ6ISpOb/gBLOJRnfXiw+mT5OKbriSVrPfMkB
         1dYfd/psVWLloR2+kK7iSOQmN4owg805OkoXYo7xZ7pSZt0oP4R3EraXrTYWVIyTxf98
         Q1Vy8idyFj/3fVJbWeULxnC/xS0kaSF3HT4jh5tyFyWeE/SjzqZp+AX7BVLT4AlG71mt
         JoAgoYFv4nVdb5x7UdRwR2UKba3JdEOc5LDiZFR5CppS42Fg58BV/5ZrsskrJth1cFXz
         cviwcht3xj9xlMeYe4gvxMk3b3fX9rx63gBARAzakIVhhOpTVHY6WU2dW+6N7eqjaLHR
         ObUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790217692; x=1790822492;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0nzk71Z/a/OJRy4Wvd2k18mEehJYeU7+sulfI7+0Deg=;
        b=ziyxeTWBZxZphB402bJO5ca7+9dfBzQcuT3O1/p5aypuoWR2IfKn/OByTbGT/J3kGP
         JI4lJwR9+jGERq3eu9FITzI29o5tx7HvKmTzScKCzhKYPAdbr86FIx8zrAxueXyZzylO
         Fvenk8VE39QPFp45EDYG/V496N7AqlIVBWkgXkj6NR2BhWen7lTFvyIYVFOrXuyk3dtF
         /XzhugMVjqtzzavxZlzy3ESVXkgqRXIgqqPOE04YvvqjkDXA7hLdJd5bBtO6S4CAlkbz
         9wmFDzLbOm61ymjr03x6TOW9B3V680EBK+1VbDiGhLrqj1i9gUhx8JE+21nyhGBzP3z/
         TuJQ==
X-Gm-Message-State: AFuF++kLHR9YHq3CJPmFoSB0v+Fe8bMCvrG/REDp/Wo1oPQ6d3PUR0LJ
	JuVpb+mEokaJPCYnuoQwQHFdv2vwQhhJQD7h5UytmqSrmcCPaRUAo19bAYP9gd0PB14W52wyN8n
	D8Kpd1aiKzT4S4Q3aS4BwR4eMY2nQTd4qLnJs/GBtWwv9AZ72DytsAJSDY/nOxbFXRTO3TWqmyg
	HR
X-Gm-Gg: AYBFou1I5ZSxHNZJJylgU2P3pG4L4j8sR7BkYaHjsosqk5AHjVfNjZXM1VVJDg5qTeT
	awZ6KXrKYjph4BjqrqxoUFD5Pd6G26BErihMNqlAhoYXipHq+bxq3lC5jMjhkrNh+mBN5jf9Ll1
	Qdox7DA9Z6UZSbbi/1ClPvhneTiUShmED9qNI6YTUFqoU1j9WAep8DpQFBPyatayQv3krRUtmUi
	3ZprDoN6D4ALABH0gim+InWmcLguWztL4PF+ZADFnBNynOI6f5MVZI8TX35bYzFkgt5iBbbeu2W
	tduep3DOpZh34Bau8iKXnUc83rFEwTU1L4jqjlsKdFGUt2XbwUNZQMQTIHL9UNFzRMeeKo+goSH
	f6ku6y7EaJdANV5cqFpUExZ9Ch6feqsiHEiZFvEpfR4WvUP56+JH45G/nrAfm2hRIn9aQfV0Rm0
	tftG41J3sxHVI4rPAIgIsbPA==
X-Received: by 2002:a05:7301:f21:b0:33c:e95:2eb2 with SMTP id 5a478bee46e88-3400171d8f9mr794847eec.41.1790217691968;
        Wed, 23 Sep 2026 19:41:31 -0700 (PDT)
X-Received: by 2002:a05:7301:f21:b0:33c:e95:2eb2 with SMTP id 5a478bee46e88-3400171d8f9mr794818eec.41.1790217691115;
        Wed, 23 Sep 2026 19:41:31 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96258351sm9692263eec.12.2026.09.23.19.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 19:41:30 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Subject: [PATCH wireless-next v2 00/16] wifi: Add Seamless Mobility Domain
 (SMD) AP support
Date: Thu, 24 Sep 2026 08:10:37 +0530
Message-Id: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKiNtGoC/x2M0QqDMAwAf0XyvEAt2FV/RfZQbTYDMxuJbIL47
 1YfjztuAyNlMuiqDZR+bPyRAv5WwTgleRFyLgze+eBaF9HmjHVoY4iNy3ffQCm/Sk9er0sPf1Z
 6kxkKrQs8ih6SEQ6aZJzO1ZxYYN8P3DHYeXsAAAA=
X-Change-ID: 20260908-smd-16986850d725
To: Johannes Berg <johannes@sipsolutions.net>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: qSQFLUZlVR-BD5Wcog0VyTgtcXMahQdG
X-Proofpoint-ORIG-GUID: qSQFLUZlVR-BD5Wcog0VyTgtcXMahQdG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfXwIwTUupAZ2mm
 KB4GZwa9LFFZrSNragwXNjrwuNo53/XHsQHBl9J41La2i4x6gEViE4JvG2sjv/8P7lVnToX6cG1
 CU41pm0lLOeKhiNcUffaMGX18/L22qmEaLaKDZfLHthx8lMHoXaKT7lTzaOVzKPD/sPeI311HgH
 7hFIu8iFyyQnRqfOQUqZkCXlfo83Q0tQF1o9D9IymolM8lceu/614XJKUscPT1z0T18gkeQDTxi
 OBHoNN1FYfZQjxOEi5MJpiqhU7JY1VAjfX7RRPkqS6dnS8diWxBga1S/vYorzJT0nNKQcimy6Fy
 DSWiueBx5aVUAIwAcy10i15EO4EUNlr5h+/UoyiHKE8Eq2oRVZBg2Ngds30W6NuGHY28CWsgU/T
 w2N6dmVTyi42fUWiEHOuRFk/S5aPoqUiSCWsnF4ZZYw7SuHNiEcjoLXcikFUYoDvP08Trjl6sI4
 1p8g+8VPzlTKmOLtx8Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfX8JzD7GLMWbhu
 8K2EDyCOQcoVagLu0UpYcgrAC30SrXCVLDitMRKHHUGBxCmQmsPXVe27QL3EiMavPYdwRUvDKwD
 /9NMl2aGXVGhXVELCRwnbT9ulLt5IFQ=
X-Authority-Analysis: v=2.4 cv=f7vdl+yM c=1 sm=1 tr=0 ts=6ab48ddd cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=F2qdJgZ5oIuqAjiy4j8A:9
 a=8cEOZIRkEOD5qctY:21 a=QEXdDO2ut3YA:10 a=bBxd6f-gb0O0v-kibOvt:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 bulkscore=0 impostorscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240012

IEEE P802.11bn introduces the Seamless Mobility Domain (SMD) - a mobility
domain uniquely identified by the SMD identifier MAC address - where
a non-AP MLD that is associated to the SMD Management Entity (SMD-ME) can
transition from its current AP MLD to a non-colocated target AP MLD
without requiring reassociation via SMD BSS Transition (ST) procedure.

This series implements the nl80211, cfg80211, and mac80211 support for
SMD BSS Transition in AP mode. Along with a summary of the ST procedure,
the design of this series and patch structure are presented below.

The ST procedure broadly involves
  - ST Discovery and association to SMD-ME
  - ST Preparation
  - ST Execution and Downlink Draining
  - ST Context

The communication between the current AP MLD and target AP MLD are via
Inter-AP (IAP) communication (solicited and unsolicited) over the backhaul
which is managed entirely within userspace (hostapd) - as per the
discussions on the RFC [1].

The IEEE standard defines only the type of data that may be exchanged via IAP
but does not define the format and method of the IAP communication protocol
and keeps it out of scope (subclause 37.16.9). So, those details are not
part of this series.

ST Discovery and association to SMD-ME (subclauses 37.16.2 through 37.16.4)
===========================================================================
A non-AP MLD may use techniques like active scanning, neighbor reports,
or BSS Transition Management to discover the neighboring SMD AP MLDs.
Once discoverred, the non-AP MLD can perform authentication and
association with the SMD-ME and negotiate SMD capabilities. While
generating PTK, based on SMD PTK mode, either SMD Identifier is involved
in the PTK formula or only SMD KDK is generated.

 - This series supports configuring an AP MLD as managed by an SMD-ME
   with attributes such as SMD Identifier, SMD Preparation Timeout, SMD
   Type, PTK Mode, etc., via NL80211_CMD_START_AP.
 - This series supports managing the associated non-AP MLD that has
   negotiated SMD via NL80211_CMD_NEW_STATION and
   NL80211_CMD_CHANGE_STATION.

ST Preparation (subclauses 37.16.5 and 37.16.6)
===============================================
The current AP MLD and non-AP MLD can use BTM frames to select a target
AP MLD that the non-AP MLD can transition to. Once the target is
selected, the ST procedure is invoked in two phases: ST Preparation and
ST Execution.

The non-AP MLD sends an ST Preparation Request (UHR Link Reconfiguration
Request frame to with Type set to ST Preparation and Per-STA Profile
subelements of the setup links for the target AP MLD carried in a
Reconfiguration Multi-Link element) to the current AP MLD.

On reception of this frame, the current AP MLD collects the non-AP MLD's
dynamic sesion context and attach it to the same frame while delivering it
to userspace. Userspace then sends this information as an IAP message to
the target AP MLD. If Per-AP MLD PTK mode is used, DH key exchange
happens in ST Preparation to derive the new PTK at the target AP MLD.

The target, once processed the message, will set up the links as rquested
and sends back the ST Preparation Response so that the current AP MLD can
send the ST Preparation Response (UHR Link Reconfiguration Response frame
with Type set to ST Preparation and statuses for each setup link) to the
non-AP MLD.

 - This series defines the layout for STA's dynamic context and supports
   reporting the driver-attached STA's dynamic context along with the frame
   via NL80211_CMD_FRAME event (this avoids roundtrips between driver and
   userspace to separately request context for the recently received frame).
 - The target AP MLD leverages the existing flows to set up the links
   (NONE -> AUTH -> ASSOC).
 - This series supports moving the STA to the prepared state (4a) via
   the new STA flags (subclause 11.3.1).
 - This series supports programming the STA's dynamic context via
   NL80211_CMD_SET_CTX on the target AP MLD.

NOTE:
(a) While implementing the suggestion to follow the approach similar
to how radiotap headers are attached to the SKB, for tagging the STA's
dynamic context to the frame SKB from driver to mac80211, an alternative
approach was found.
(b) This reserves a new field in &struct ieee80211_rx_status as part of
an existing union (please see this patch [2]). Since this was simpler
than _pushing_ the context pointer to the frame SKB and _pulling_ back,
this series follows this approach.

ST Execution and Downlink Draining (subclauses 37.16.7, 37.16.8, and 37.16.10)
==============================================================================
When the non-AP STA is ready to transition to the target AP MLD that it
has already been prepared with, it can send the ST Execution Request
(UHR Link Reconfiguration Request frame with Type set to ST Execution)
in two ways:

Via the current AP MLD
----------------------
This path traces a similar flow to ST Preparation for context collection
and reporting to userspace of the current AP MLD, transport to the
target AP MLD, and ST Execution Response back to the current AP MLD and
non-AP MLD. If there is a Nominal Maximum DL Draining Period Duration
field is present in the ST Execution Response, the current AP MLD may
start the DL draining period to drain the pendign buffered frames to the
non-AP MLD.

 - This series supports moving the non-AP MLD to the execution
   in-progress state (state 4b) via the new STA flags on the current
   AP MLD
   upon reception of the ST Execution Rquest.
 - This series supports moving the non-AP MLD to the DL draining started
   state (state 4c) via the new STA flags on the current AP MLD and
   implements proper validation for these flags as they are mutually
   exclusive.

Upon successful ST Execution, the non-AP MLD moves to the authorized state
(state 4) on the target AP MLD and the unauthenticated and unassociated
state (state 1) on the current AP MLD, without reassociation.

Via the target AP MLD
---------------------
The non-AP MLD might send the ST Execution Request directly to the
target AP MLD when the current AP MLD links are not reliable (RSSI drops
after ST Preparation, etc.,).

When the target AP MLD receives such a frame, it cannot collect the STA's
dynamic context. Hence, the context is requested from the current AP MLD
via IAP and then programmed on the target AP MLD. There is no DL draining
in this path.

 - This series supports fetching of context on the current AP MLD on
   behalf of the target AP MLD via NL80211_CMD_GET_SMD_CTX and
   NL80211_CMD_SMD_CTX_EVENT.

ST Context (subclause 37.16.9)
==============================
The following information are part of the STA's dynamic context and transferred
from the current AP MLD to the target AP MLD during ST Preparation and
ST Execution:
 - Block-ack parameters and timeout per TID
 - Next DL sequence numbers per TID
 - Duplicate receiver cache entries
 - Replay counters
 - Starting PN for DL individually addressed frames
 - SCS stream descriptors
 - MSCS Descriptor
 - EPCS authorization info and priority access state
 - WinStartO for existing DL block-ack agreements

The non-AP STA may optionally request that sequence numbers not be transferred
(to reset SN at the target AP MLD).

This series suporting the SMD BSS Transition is structured as:
 - AP configuration: patches 1-3
 - STA association: patch 4 and 5
 - SMD BSS Transition state machine: patches 6 and 7
 - SMD Context handling: patches 8-16

[1] RFC: https://lore.kernel.org/linux-wireless/fbf4209c-4fd8-4047-96d7-7fa34d9ba44d@quicinc.com/
[2] Patch 11 ("wifi: cfg80211/mac80211: Handle UHR Link Reconfiguration frame")

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
Changes in v2:
 - Replaced SKB extension with a mac80211-contained solution using
   ieee80211_rx_status to forward the ST Preparation and Execution
   frames along with the context.
 - Fixed cover letter, commit text, and kdocs to clean up the
   AI-suggested style and words.
 - Fixed the build failure from v1.
 - Rebased onto a latest snapshot of wireless-next
   (6c0b7357e3c7f365ec51dd8d2b626130ee983ce1).

v1: https://lore.kernel.org/all/20260908-smd-v1-0-65ad4ab30fbd@oss.qualcomm.com/

---
Aditya Sathish (2):
      wifi: nl80211: Add kernel interfaces for Seamless Mobility Domain setup
      wifi: cfg80211/mac80211: Parse SMD parameters in STA addition/modification

Pooventhiran G (11):
      wifi: nl80211/mac80211: Add SMD BSS Transition sub-state STA flags
      wifi: mac80211: Add driver_op for SMD substate changes
      wifi: mac80211: Send BlockAck policy in AMPDU action
      wifi: mac80211: Define layouts for SMD BSS Transition context
      wifi: nl80211: Define attributes to pack SMD BSS Transition context
      wifi: cfg80211/mac80211: Handle UHR Link Reconfiguration frame
      wifi: nl80211: Pack SMD dynamic context along with frame
      wifi: nl80211/cfg80211: Add support for SMD context programming
      wifi: mac80211: Add mac80211 support to handle NL80211_CMD_SET_SMD_CTX
      wifi: nl80211/cfg80211: Add support for querying SMD context for target AP MLD
      wifi: mac80211: Add mac80211 support to handle NL80211_CMD_GET_SMD_CTX

Rohan Dutta (2):
      wifi: cfg80211/mac80211: Configure AP with SMD capabilities
      wifi: nl80211/cfg80211: Indicate STA creation via SMD BSS Transition

Sidhanta Sahu (1):
      wifi: nl80211: Define Seamless Mobility Domain (SMD) device capability

 include/linux/ieee80211-uhr.h | 149 +++++++
 include/net/cfg80211.h        | 115 ++++++
 include/net/mac80211.h        |  80 +++-
 include/uapi/linux/nl80211.h  | 302 ++++++++++++++
 net/mac80211/agg-rx.c         |   1 +
 net/mac80211/cfg.c            | 170 ++++++++
 net/mac80211/debugfs_sta.c    |   4 +
 net/mac80211/driver-ops.c     |  24 ++
 net/mac80211/driver-ops.h     |  54 +++
 net/mac80211/ieee80211_i.h    |   2 +
 net/mac80211/rx.c             |  96 +++--
 net/mac80211/sta_info.c       | 146 +++++++
 net/mac80211/sta_info.h       |  19 +
 net/mac80211/trace.h          | 117 +++++-
 net/wireless/core.c           |  25 ++
 net/wireless/mlme.c           |  30 ++
 net/wireless/nl80211.c        | 941 +++++++++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.h        |   9 +
 net/wireless/rdev-ops.h       |  28 ++
 net/wireless/trace.h          |  73 ++++
 20 files changed, 2343 insertions(+), 42 deletions(-)
---
base-commit: 6c0b7357e3c7f365ec51dd8d2b626130ee983ce1
change-id: 20260908-smd-16986850d725

Best regards,
-- 

