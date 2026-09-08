Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566E5552950
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 17:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788887404; cv=none; b=LdHFSKLVCcH74+04oySKK7MxH+xiG9T1fUZftEYGxY0IpjaG2h/mDHqAPjB6RMFIxQGSyUB8BOuRnixSTaJsjyafI9mc0kb7eqKxx8Kb97xIXAUlZDtZDVceWbxGm/aDa98D57W21ufcwVaC4EBav5ESQB6KAvziXu7Vf/2s3FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788887404; c=relaxed/simple;
	bh=xH0xcj/8vIiYjyrGF1xp0a3lv3Ll1FQIuJAs54n5Sow=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=rM0QjhIpH1/Qc9Xa3gMCTjLPwXaL2bH1xNAfsflZc42G9cKuinFq/dnfw8uXuaOf8gtPITYJqD2Z3FveqyY1CynTjE3jAthaZ+Flz8KWTBmELjf/7O8aPJXe4YrhKFE11/jIscDrlNmeuddaZNrDYlQrwAx4FHQjPCEQV2JO/eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KIA2kuej; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hcvNpse8; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KIA2kuej";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hcvNpse8"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FdcPN3429869
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 17:10:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=QAf9itNhLtoKXsIvPQiM+O
	g4kU/n8TuTmvbZbJIJQWQ=; b=KIA2kuejdhBELiQLFKUdykIsdAv/7SznyxK//N
	WBc2bJQMmEy3xv4W8t2PPR/ijjBiYh1E9bLXBDfSSl388WBdjWBdNB3A6EVZifQp
	zWnOXcybqnLzZlOoFtam+401Q/OAO5kiI/ASyIvAhNPYxg5BohQIkVIuzmYx6R9Z
	yd+vd2Ht27LaTI0o/pLK2DHj6UWfzehtzL/3KNZepXclAhAXH03ePj/rTN+n8Ss9
	y02B/XE0c9IM0s3MfzBhtyNW5BWcfbn3fhFxE7JEzDac7Mog711FZJ4YnZjfN25O
	6Rjh5yqlO0vuFAsgco7+mUfsIleiTB11MHJQYqkObAiBlNew==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjhkj1n6k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 17:10:00 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc1eb205d31so2756867a12.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 10:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788887400; x=1789492200; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QAf9itNhLtoKXsIvPQiM+Og4kU/n8TuTmvbZbJIJQWQ=;
        b=hcvNpse8/M1LowOwQbfAdA6fZTouMAaQ7MtxhIG3AIJXCKtEg+rFDFBW4cZxqQRnqh
         WImubI6lFr0TNsVHkTq9YnTbQvfhLOEj0T6Q+w0SOXrMFOC5Joxxa5ykWVPAHBvzDBVx
         RIVKhIgywzKDwXAMZsNtO6zCLo/I/mzFyGvXQs0fUcNLplP4BKP4UnIvmQNXeRIVui8T
         u64UC9G8ppwDslBPnYiKEcfxpIVsbkDNWv2fDAFEzVOQ7ivy6duWWjI+mdCz0oz2OPKG
         PHWG5gcd+vz69KhzFsI6AwYCTIgij7HhFUcs4sYZQsNEA124otXKYku9ILaIvk2cOd0y
         UrJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788887400; x=1789492200;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QAf9itNhLtoKXsIvPQiM+Og4kU/n8TuTmvbZbJIJQWQ=;
        b=dVEOWd3WwIRo738ctnHenaJbUu2zXX7QF+p7X6AqjCZ59Mry2vEBtZ/kyaqNLrqm6a
         sjJaFWaJzVmH7zDFlrUD/3X7D/afTB/R6deGjKSNDc4CdxE+V2FpTF9dYFygYTHil69b
         Debko071RUWBsXH0KNPGGDjlbFTs6T9J1FKzoSn1A6UrsGZX1D/iZhM8HwJ/8wKL744U
         MqX2W9gtVFwxYi/xbgNSVK79N76E1NqF96crAbGEIB8iqEiVx/3fpzOcP2aaDvrstO0m
         KwfFjYfEp92zKGqpZbQoq53QBU0jLigOfDRA4qJNHFc5NUbRhNiD4f4X0BK4JOAX1VVW
         SroQ==
X-Forwarded-Encrypted: i=1; AKwUvBz5gpvDUDhMG73Bjrgvmd6XX2SNsf1VOGsJPlMbcID2cDZ2wKG0jQDdJfXInZchGVW3vR7WHOlSMhfrzcShaA==@vger.kernel.org
X-Gm-Message-State: AFuF++mZeN6KwBFrZmsk6iYZESXnIYiy8H94No9IW2LW5ciapM2OyB50
	8b5c33H4QzQBLnND+9haFJSJv0PZa8ncJarWxgVLmMwOY/w/8ftNd7bMTkEkBdz1N1jzsVBAwZX
	APpwy9AqSd00YcBEO8VfA4ZhDtj8IC954ZOK9mt0ytdbCqOawSKjQOiYK62/ZL9W01bSL
X-Gm-Gg: AYBFou08T02stt1lCjgKOgqKsRFh5qIPRAo7RXg9aJEFrCKHYXAPDrrLYHL+wPuFh0K
	MQH6p/pjvK4DrPaaR+qmUMuI6jKLQVKAeZ57pLdxYPj/TZ4H/3ffSTa5VYVILoWHj4wpkHEf5nP
	4dNeATnbdOMk39CycPRO6yfpGuATdKhk85tLelS3AWnXPxvFYjdz4pNdnwxbdZ0QF+CifDjXv0g
	DdH3k3mj+Epzey7Wo3C0L8wCaP8ipXFWkOmOs6c6dliBosXuv+/6UOqAvkUBFuSn5qxEFu4Z0eO
	VRcM3jpq0DXhBymyCCxSOEUQKjqEcgmnUMDj9PVAPnp3gyKd1oXCNyxL+k3c35xG0tatKLdwuOv
	+FzS3Pzxc4czCrYPpYRqdP7KXQ+zdubH6ZtPr5coSxaIbFFH0+hIdD5Vdejq+MWFlZc/Ow4fbVI
	lemgtA+/OvVo/AIbQoepFuWA==
X-Received: by 2002:a05:6a20:e607:b0:3d3:ae0f:5267 with SMTP id adf61e73a8af0-3da3a152a11mr47964894637.19.1788887400101;
        Tue, 08 Sep 2026 10:10:00 -0700 (PDT)
X-Received: by 2002:a05:6a20:e607:b0:3d3:ae0f:5267 with SMTP id adf61e73a8af0-3da3a152a11mr47964813637.19.1788887399377;
        Tue, 08 Sep 2026 10:09:59 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33450e140d3sm31773675eec.4.2026.09.08.10.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 10:09:57 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
To: "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Subject: [PATCH RESEND wireless-next 00/18] wifi: Add Seamless Mobility
 Domain (SMD) AP support
Date: Tue,  8 Sep 2026 22:39:28 +0530
Message-Id: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.14.3
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX6efVcz7y6HNn
 jN2qBJOyGTxHSuIatzJVSuQaOy8YyXUknGfQXfjuk+kP1hNUIHQJHUQnLEM73Fqzsi9mrQ/u28g
 0QYZoOq3wpRk8+Dg+n65CcswcrYcnOU=
X-Proofpoint-GUID: rQotwvnRh2pW30Yy8QUD3BkPbG_5vA-0
X-Authority-Analysis: v=2.4 cv=VYjH+lp9 c=1 sm=1 tr=0 ts=6aa04169 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=5AEPK_u2OLHVUZgZUq4A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: rQotwvnRh2pW30Yy8QUD3BkPbG_5vA-0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfXzsoGXvAtgWP8
 ir2tsGB0gi1D4WEzn25pP3TbM+uIEfMiwusFlNyRlYmxqVUtrOnwDWn3p7jH6RDM37PqzLe17Sz
 v8vfrZviCvDwMP2XUaKTlFOsszGidHGXH06duFMCmnxmT7C3pcjMGmxhgllr16j/mWc+Ncrcghr
 dumPcvzXqXjV6viIo4Pe7FkiCdtDFt0kRfbDjrBLvwahCGeA2kAImGMUObGXNuAPFiqXF1h/yKJ
 VxGGcSr7/D+BpUmNv4y8e+bRRWZ0SQ3zXRAjwuwGALJiyZtptcsctQtkldgKz9kihqsbPFdwJ54
 f21OIR/eFQO52kVpBtKst8ao66C9LddHY5lA6Dv1FqBgcerVYhNfTHA83H6R/nlQhAuwRiCIfwC
 EKo9QBGq3pfpE03/udH6UdaN/Qw5ZqgXg5rzlggXITEgro6ktYqJaVmn/l5/1yu++9VGlTEosrG
 4ORqN43GTJfLpSQ7XiQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080185

IEEE P802.11bn (Ultra High Reliability) introduces the Seamless Mobility
Domain (SMD), a mechanism by which a non-AP MLD can transfer its session
from one AP MLD to another within the same administrative domain without
losing its RSNA or experiencing a visible connection break. The key
properties of an SMD are:

  - A shared domain identifier (SMD-ID, encoded as a 6-byte MAC address)
    advertised in the beacon of participating AP MLDs.
  - A Seamless Transition (ST) protocol in two phases: ST Preparation
    (cryptographic handshake and resource reservation on the target AP)
    and ST Execution (atomic handoff with optional DL draining).
  - Session-context transfer: the current AP MLD collects the STA's
    DL/UL sequence numbers, block-ack parameters, PN values, and QoS
    descriptors and conveys them to the target AP MLD so the STA can
    resume without re-association.

 1. ST Discovery (37.16.2)
 --------------------------
For a non-AP MLD: ST discovery of an SMD capable AP is via OTA signalling
 in beacon/probe responses.
For AP MLDs: Discovery of partner AP MLDs within the same SMD is via
 Inter-AP (IAP) communication (solicited and unsolicited) over the
 backhaul.
 IAP is housed entirely within hostapd and the communication happens
 between hostapd of AP MLDs.

The spec defines only the type of data that may be exchanged via IAP but does
not define the format and method of the IAP communication protocol and
keeps it out of scope (subclause 37.16.9). So, those details are not
included part of this series.

SMD capabilities are indicated to the mac80211/driver via NL80211_CMD_START_AP.

 2. Association to the SMD-ME (37.16.3)
 ---------------------------------------
Before roaming, the client must perform a single association and
authentication with the SMD-ME through any AP MLD in the SMD. This establishes
the PMKSA and PTKSA at the SMD level that will persist across all roams.
SMD capabilities of a non-AP MLD is indicated to the mac80211/driver via
NL80211_CMD_NEW_STATION.

 3. PTK Derivation (37.16.4)
 ----------------------------
Key derivation have seen some standard update and its to be taken care in
hostapd/wpa_supplicant, updated PTKs are plumbed to the mac and driver using
existing legacy netlink commands. PTK derivation uses SMD MAC address
(SMD identifier) and also derives SMD KDK which is used in lieu of PMK for
multi-PTK roaming. This is accommodated within hostapd using legacy netlink
commands.

 4. ST Preparation (37.16.6)
 ----------------------------
This is the key step that enables seamlessness. Before the actual roam, the
client pre-provisions the target AP MLD:
- The non-AP MLD sends an ST preparation request (a UHR Link Reconfiguration
Request) to its current AP MLD, identifying the target AP MLD and the links to
be set up.
- The driver in the current AP MLD, when forwarding this special frame
to mac80211, collects the station session context and appends it to the
frame skb using skb-extns so that mac80211 can deliver it via a new
NL80211_ATTR_SMD_CTX attribute in the existing NL80211_CMD_FRAME.
- This method saves the round-trip from driver -> hostapd -> driver to fetch
the context.
As the context is to be sent with the frame skb (as context is per-frame) and
may be big, SKB extensions help carry the related context within the same
frame skb.

- The context collection happens in the vendor driver and the same is passed on
to mac80211 for forwarding to hostapd.
- The current AP MLD transfers the collected session context (block-ack
agreements, sequence numbers, replay counters, SCS streams, MSCS, EPCS state,
starting PN values) to the target AP MLD over the backhaul IAP.
- If Per-AP MLD PTK mode is used, a DH key exchange occurs in the preparation
frames to derive the new PTK at the Target-AP.
- The target AP MLD sets up the links (NONE -> AUTH -> ASSOC + SET_KEY), and
enters the prepared state (4a), and sets the context via NL80211_CMD_SET_CTX.
- The target AP MLD builds the ST prep response with the target AP MLD's full
capability profile (Basic Multi-Link element with per-STA profiles for each
accepted link) and sends it over the IAP to the current-AP MLD.
- The current AP MLD responds to the station with the OTA ST prep response
and a preparation timeout is started at both the current and target AP MLDs
(duration for which the prepared state is valid).
- The client can prepare multiple target AP MLDs simultaneously (up to the Max
Number Of Prepared Target AP MLDs advertised by the current AP MLD).

 6. ST Execution (37.16.7 and 37.16.8)
 ---------------------------------------
When the client is ready to roam, it triggers the actual switch via one of two
paths:

Via the current AP MLD (37.16.7):
- The non-AP MLD sends an ST execution request to its current AP MLD. The
current AP MLD moves the station to the execution in-progress state (4b)
and transfers the current context, notifies the target AP MLD, and sends
back an ST execution response with SUCCESS to station.
- Context collection mechanism for Execution is same as Preparation.
- The response includes a Nominal Maximum DL Draining Period — a grace period
during which the current AP MLD may continue forwarding buffered downlink data
to the non-AP MLD before the old link goes away. During draining, the current
AP MLD moves the station to the draining state (4c).

Via the target AP MLD directly (37.16.8):
- Used as a fallback when the link to the current AP MLD has deteriorated
(e.g., after ST preparation, the RSSI to the current AP drops).
- The non-AP MLD sends the ST execution request directly to the target AP MLD;
the target AP MLD fetches remaining context from the current AP MLD over the
IAP.
- The current AP MLD uses NL80211_CMD_GET_SMD_CTX to pull the STA session
context on behalf of the target AP MLD and forwards it to the target AP MLD
over IAP.

The Target AP in both cases plumbs the stations context to the mac80211 and
subsequently to the driver via NL80211_CMD_SET_CTX.

Upon successful execution:
- The non-AP MLD enters State 4 with the target AP MLD (fully
associated/connected) and State 1 (unauthenticated and unassociated) with the
former current AP MLD post draining.
- No reassociation is required; the client retains the same PTKSA and IP
address.
- TTLM (TID-to-link mapping) reverts to default mapping mode initially.

 7. Context Transfer (37.16.9)
 ------------------------------
The following per-client state is transferred from the current AP MLD to the
target AP MLD during ST (preparation and execution):
- Block-ack parameters and timeout per TID
- Next DL sequence numbers per TID
- Duplicate receiver cache entries
- Replay counters
- Starting PN for DL individually addressed frames
- SCS stream descriptors
- MSCS Descriptor
- EPCS authorization info and priority access state
- WinStartO for existing DL block-ack agreements
The client may optionally request that sequence numbers not be transferred (to
reset SN to 0 at the target).

 8. Downlink Draining Period (37.16.10)
 ---------------------------------------
After ST execution, the current AP MLD may continue transmitting buffered DL
data to the non-AP MLD for a controlled grace period:
- The period duration is signaled in the ST execution response.
- Both the current AP MLD and the non-AP MLD can signal early termination of
the draining period via a UHR Link Reconfiguration Notify frame.
- During draining, the non-AP MLD is not required to listen to Beacons of the
target AP.

This series adds the kernel infrastructure needed to support SMD in AP
mode. It is structured as below logical groups:

 - SKB Extension definition: patch 1
 - AP configuration: patches 2-4
 - STA association: patch 5 and 6
 - SMD BSS Transition state machine: patches 7 and 8
 - SMD Context Programming: patches 9-18

RFC:
https://lore.kernel.org/linux-wireless/fbf4209c-4fd8-4047-96d7-7fa34d9ba44d@quicinc.com/

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
Aditya Sathish (2):
      wifi: nl80211: Add kernel interfaces for Seamless Mobility Domain setup
      wifi: cfg80211/mac80211: Parse SMD parameters in STA addition/modification

Pooventhiran G (13):
      net: skbuff: Add SKB extension support to wireless drivers
      wifi: nl80211/mac80211: Add SMD BSS Transition sub-state STA flags
      wifi: mac80211: Add driver_op for SMD substate changes
      wifi: mac80211: Send BlockAck policy in AMPDU action
      wifi: mac80211: Define SMD BSS Transition context for transport
      wifi: mac80211: Enable skb extensions along with mac80211
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

 include/linux/ieee80211-uhr.h   | 149 +++++++
 include/linux/skbuff.h          |   3 +
 include/linux/skbuff_wireless.h |  55 +++
 include/net/cfg80211.h          | 115 +++++
 include/net/mac80211.h          | 124 ++++++
 include/uapi/linux/nl80211.h    | 303 +++++++++++++
 net/core/skbuff.c               |  55 +++
 net/mac80211/Kconfig            |   1 +
 net/mac80211/agg-rx.c           |   1 +
 net/mac80211/cfg.c              | 166 +++++++
 net/mac80211/debugfs_sta.c      |   4 +
 net/mac80211/driver-ops.c       |  24 +
 net/mac80211/driver-ops.h       |  54 +++
 net/mac80211/rx.c               |  22 +
 net/mac80211/sta_info.c         | 146 +++++++
 net/mac80211/sta_info.h         |  19 +
 net/mac80211/trace.h            | 117 ++++-
 net/wireless/core.c             |  25 ++
 net/wireless/mlme.c             |  32 ++
 net/wireless/nl80211.c          | 941 +++++++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.h          |   9 +
 net/wireless/rdev-ops.h         |  28 ++
 net/wireless/trace.h            |  73 ++++
 23 files changed, 2455 insertions(+), 11 deletions(-)
---
base-commit: 1b60ed34f712e9f606d80951f1586f4274ebadf1
change-id: 20260908-smd-16986850d725
