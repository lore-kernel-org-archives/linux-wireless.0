Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610F41FF7C5
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792043691; cv=none; b=hTebGh3lEd0YG/Hnv54yDWFUqZzQOCZZrV4ycsu+kyse9LSKUZOfR3GcqqcuxepLIkq32uXb4Wmp2Mxc2D3aSfWTl36qZlsB7759ZF9Vwda+RdorXQdJhlddmkzSAUBDVCd2NWRmae3feBkPKJ3f64MAZuqinuYL6V1HY0d7FSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792043691; c=relaxed/simple;
	bh=MlwFplp9kn9YQOQPZwVuj6VzXUifja1SAGQemq4b+Co=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nRBKNDtLv2CBLmpdu1/IigYpd3yzcnARlHovzJiUjpBogOXMA8jd9U5BQtY0FRO7K+JUcL0Q7+VNzwxqVtFVw96mhdi3FjpjrM7jm3uDgVPUrYz9Pn9ttCwnnXP+LmRjIOBaBNnqnCKf2p9Fcv32uXQcv5VAYK5OqGpAuCmmX5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ng3WBJg5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hTZAgYYB; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ng3WBJg5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hTZAgYYB"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F1R9jE3469372
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:54:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=A75f2xxYnB8eKx443wh48OrbfwXotpjXVBQ
	hOZKxNf4=; b=ng3WBJg5hkRFKFMzsqBJ2dqpcCFDTbH8ihrbwUtD/5Le3+3N7Va
	ALJLUSb8XMsdx4huP0Zi+ATkI5n7OgE/kcZHspz6EPnLGMXO7yXgQ+uiKR+9siEx
	US7P/0ZSJmcT8Tfn9Ln+h7IUkGMqR12CxSCQ/9ZW7FhfLDtml/uLDK8ozgBYbL5a
	QuD+cwbeNAj96UaEclT29RuLBGEVSaIOl0sNitDU9bZA92hfkZJy0g0H1YSmZdEv
	jLihkPppBeCwTxEZICgVLfIG9rcjJqa+8WLK5GM4bgabspDFPY7T83S3CQj6zhVx
	9Cf2G7VkzqDG/vkFOe1bkhIyc+q6RZO95ZA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hadd7akx9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:54:49 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3a8af172664so1138901a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 22:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792043689; x=1792648489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=A75f2xxYnB8eKx443wh48OrbfwXotpjXVBQhOZKxNf4=;
        b=hTZAgYYBK++5KPczwDo1W6yQ3x3OPR3zF2K7UUu405oc3XpIPCx6rs8Kd7jNq6No5K
         1XA94LlD89PTS4Xi72gijdWLzvqWPjU0WNG52ns9pWMA9+NhDDz3JnpXhGSBo47sEE2Q
         f0ExU9hKSN1UkbR0RPY7tIUg7BfNNboAmhW3p6c1VSrp3dAJOBPljgyPtTNiocPtBYc/
         a9J4lUeLfZQKQiNA9tc4jP3n9MljLaWb2NXBq9gv0+54bOZWGxztaevjURh4L6RiZ7mP
         YFq68qXb++4RDIdru/GKQdlLMaCg6WuHL9sbP3lbxWWzUFC4GEuGfkp1HmqEt8nd7xdq
         T+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792043689; x=1792648489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A75f2xxYnB8eKx443wh48OrbfwXotpjXVBQhOZKxNf4=;
        b=m/cFt8eGXQjvIdF0JFJaAQFiGg03i7CWdjxZphS68pyUY4FmODKdPeRbKSkNqicIW0
         NAc9eD1fxwGlSX4dJYJalgedoDl6rcoXO6ckxl5fOf0NxdxFkMHIdoksA/vwUAf4sV9H
         gcQLAlxnJ5/nEnifZTY9mKgr1I3fI25x29ZJnRhNkqfMy0vslut3pWqdrSKm8WWNxtDJ
         pDIOZKJnhsuyUiMpIkRguuGiJflNRGCihr+yIZ8uzu6kL75+BojDx/Img11UA4p9Z/M7
         X7TgW5i5JaR/x9GNwydNzmvocb7BrT65y+xFAE7Xj0+E551/0rQg3GfX7T7+1zSAppSp
         ZaJQ==
X-Gm-Message-State: AFq9FYLo+ezusd0FEnqckEPY8rXKGX7DXKQHgqKoNsbnAUuWW95ILWcK
	5fAW04VJyG8Xcx/49roa0mHMUcNR5HEi+26AlEijPuSC3GC0ZNtHT2utTRF06YyNvn2zLRvlNpi
	ZgEiqsr8g1TmwhNlE15GMC29i55KqqwLlcic78l1eQVcrDh95NX9Ki9Sj+cHjoD2QHXrvfA==
X-Gm-Gg: AYBFou3sCR8WIBSQFMnatwaXhfZirAzI1fPozApDDEFUd0Jz5v8FkN8pc9OAixLm5fZ
	XIPdQnoyeFphnlbpwvjWCf7DNka3wJtLW4wr0ht4U3hC2xuWAtMM1uLS77huiLEa/a3fXRSgVxd
	UGyuEmakwQgiY5O4jsORSrDcXCzt1M10BFNgLVKImFbyK2sfJU59ZvJtFxb4rVPX4Z6PMtr43Y8
	ferN2rcC72ax6pujLGC6tb1LZ/m5OLHpWjXTzvfw0ILJfzDggt02hjVHkJAepKsUR++dSvy1HoY
	1UWrA+HOe65WKE0bX6SVteet5121Rs+0oXXXBH2MvpQQXN3ySJl0HH0ffptFBkFxYWG4bgLq5Tv
	yQrTo1lUvPLHi8A/js7ULpyTBgYbG5VAzPj2Lbq73LNOiHoWtRE1Ofi3PrfQa2LsZweuSH6QTgg
	5B7yENCXvccnIm
X-Received: by 2002:a17:90a:d006:b0:3aa:fc22:8aac with SMTP id 98e67ed59e1d1-3ab3a9325f8mr16227800a91.51.1792043688571;
        Wed, 14 Oct 2026 22:54:48 -0700 (PDT)
X-Received: by 2002:a17:90a:d006:b0:3aa:fc22:8aac with SMTP id 98e67ed59e1d1-3ab3a9325f8mr16227773a91.51.1792043687992;
        Wed, 14 Oct 2026 22:54:47 -0700 (PDT)
Received: from hu-aisr-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac944af2f1sm2629054a91.15.2026.10.14.22.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 22:54:47 -0700 (PDT)
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Aishwarya R <aishwarya.r@oss.qualcomm.com>
Subject: [PATCH RFC wireless-next 0/7] wifi: introduce generic QoS Management framework
Date: Thu, 15 Oct 2026 11:24:34 +0530
Message-Id: <20261015055441.680588-1-aishwarya.r@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=BaVNQbt2 c=1 sm=1 tr=0 ts=6ad06aa9 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=VwQbUJbxAAAA:8
 a=COk6AnOGAAAA:8 a=qC_FGOx9AAAA:8 a=EUspDBNiAAAA:8 a=4TnTTFher7RBZE7yRwUA:9
 a=uKXjsCUrEbL0IQVhDsJ9:22 a=TjNXssC_j7lpFel5tvFf:22 a=fsdK_YakeE02zTmptMdW:22
X-Proofpoint-GUID: fZi4Eioj2AFewfuHPWEatPlZlUq1V6Vo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfX/Rix9vtrSmwE
 c7z7aYQZxbs9Ih8EljkAfmgfAToCdE8FkI8qfKg3SrwSa+ZUmoyS564Llm80kDvP7zBFzRATRqm
 +A41nm4IH9RmKuk+WZgiHdUZC1naXByOYnPChBkWtxk4Dq/d4B3uRPc3RNZByA7xxm2L9sByZqW
 3Hs3jTpDpIkDdRv/3uLRTWXv2lNXv9P8RtUfA93+tPGxuUY215LX9I93Cnj1DLYZWDH0oIccfR1
 j2wUdEWhjFH372BKIfqGkL89pc6K6L9CctBmvLQoQy8gK5QTXuOFNNu9w/BgwJg0Y55i4ykcL5L
 9kYs5Qx4K32w+3sO6qvMvkqCcltgDRndlpxrT4FR9ILtq+BuoHih/JoL2IHpgMjZvbxdznefhq9
 LVIKEBh5sOCpTPSSOlYS4CmYzJP7HyS2QWEjEtrQ2MKu5CmJwJHdQU1XXJsDvYrYwaPFNdSU8mi
 NtBKUx9f5PEVKEiff/w==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfX3C4gclaiVUz0
 T3fDL6rSj/rZRZ1uwEwAI0PkVkAIEIrFuqtna8rJnfBeFazgfIV392W5/EwzpP/bIFTBLHWDjaE
 0oX8C8uYObS+50GUFgbAJrtnz2ek5sw=
X-Proofpoint-ORIG-GUID: fZi4Eioj2AFewfuHPWEatPlZlUq1V6Vo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150023

This series implements the generic QoS Management (QM) control-path
framework proposed in:

[DESIGN RFC] wifi: Robust AV streaming Design Proposal for AP [1]

The RFC discusses support for IEEE 802.11 Robust AV Streaming protocols,
specifically Stream Classification Service (SCS) and Mirrored Stream
Classification Service (MSCS), and proposes a generic userspace-to-driver
interface for exchanging QoS Management requests and responses.

The protocol procedures used by this series are specified in 11.25.2 and
11.25.3, IEEE Std 802.11-2024. The SCS Descriptor and MSCS Descriptor
elements are specified in 9.4.2.120 and 9.4.2.242, IEEE Std 802.11-2024,
respectively. The TCLAS element and TCLAS Processing element are specified
in 9.4.2.29 and 9.4.2.31, IEEE Std 802.11-2024. The QoS Characteristics
element is specified in 9.4.2.326, IEEE Std 802.11be-2024.

SCS and MSCS both follow a common request/response model where a non-AP STA
negotiates traffic classification and QoS treatment with the AP using QoS
Management action frames. While the descriptors used by the protocols
differ, both share request operations and per-descriptor status reporting.
SCS uses TCLAS elements and QoS characteristics, while MSCS uses a TCLAS
mask together with its user-priority fields.

Rather than introducing protocol-specific nl80211 commands and driver
interfaces, this series adds a generic QoS Management framework that can be
reused by current and future Robust AV Streaming protocols.

The framework provides:

  * IEEE 802.11 definitions for QoS Management protocols, request types and
    status codes.

  * A new NL80211_CMD_QOS_MGMT command and generic nested attributes
    capable of representing SCS and MSCS descriptors.

  * cfg80211 request and response structures together with a driver
    callback for QoS Management transactions.

  * Parsing, validation and response handling in nl80211. Responses are
    initialized with the request descriptor IDs and a declined status
    before the driver callback, so an unhandled descriptor cannot be
    reported as successful.

  * mac80211 forwarding support and RCU-protected per-station state
    tracking for successful QoS Management transactions.

  * map SCS-marked packets to negotiated TIDs and apply MSCS priority
    limiting during TX queue selection.

The MSCS packet mark retains the original uplink priority and applies the
priority limit only during transmit queue selection. This avoids
rechecking a previously limited priority against the original bitmap.

SCS descriptors carry either TCLAS elements alone (legacy SCS) or a QoS
Characteristics element (IEEE 802.11be SCS).  mac80211 handles legacy SCS
by mapping packets to the negotiated TID during transmit queue selection.
When a QoS Characteristics element is present, mac80211 forwards the full
descriptor to the driver via the qos_mgmt callback, allowing the driver to
apply hardware-specific scheduling or offload.

This series is complementary to Felix's proposal [2]. It deliberately keeps
protocol-specific flow classification out of mac80211.

For SCS, userspace and netfilter can classify flows and carry the resulting
metadata through conntrack and skb marks. For MSCS, mac80211 uses the
received user priority and the negotiated MSCS bitmap.

The corresponding packet-marking model is implemented by the QSDK hostapd
nftables integration [3][4]. It exposes a rule-management interface and
installs per-interface netdev egress chains that can match MAC, IP and
transport-layer fields and write packet marks. This is an implementation
reference for the userspace/netfilter integration; it is not currently
part of upstream hostapd. The netdev RFC describes the corresponding
packet-path support for using this metadata before transmit queue
selection [5].

This model avoids duplicating SCS TCLAS and flow-classification logic in
mac80211 while allowing userspace and netfilter to evolve
classification policies independently. It also keeps the mac80211
data path small and allows drivers to implement hardware-specific
handling or offload where appropriate.

For intra-BSS forwarding, the QoS Management mark may not be preserved
if the AP nftables configuration restores skb->mark from conntrack
unconditionally and the intra-BSS flow is not tracked.  Per-station peer
isolation routes STA-to-STA traffic through the full bridge path, ensuring
conntrack sees the flow and the QoS mark is intact at transmit queue
selection.

[1] https://lore.kernel.org/r/20250624205716.1052329-1-quic_rchoodam@quicinc.com/
[2] https://lore.kernel.org/linux-wireless/cover.3af9ba310d9145a9dfd653b5a886feaba98e8884.1788338716.git-series.nbd@nbd.name/
[3] https://git.codelinaro.org/clo/qsdk/oss/src/network/services/hostapd/-/blob/win.wlan_host_opensource.4.0.r39/src/ap/nft.h
[4] https://git.codelinaro.org/clo/qsdk/oss/src/network/services/hostapd/-/blob/win.wlan_host_opensource.4.0.r39/src/ap/nft.c
[5] https://lore.kernel.org/netfilter-devel/20261006085844.2694120-1-hari.chandrakanthan@oss.qualcomm.com/

Aishwarya R (7):
  wifi: nl80211: add QoS Management UAPI
  wifi: cfg80211: add QoS Management data structures
  wifi: nl80211: implement QoS Management request parsing and response
  wifi: mac80211: forward QoS Management configuration to drivers
  wifi: mac80211: track QoS Management station state
  wifi: mac80211: map SCS packets to configured TIDs
  wifi: mac80211: add MSCS packet classification

 include/linux/ieee80211.h    |   1 +
 include/net/cfg80211.h       | 220 +++++++++++
 include/net/mac80211.h       |   7 +
 include/uapi/linux/nl80211.h | 344 +++++++++++++++++
 net/mac80211/cfg.c           |  13 +
 net/mac80211/driver-ops.h    |  28 ++
 net/mac80211/ieee80211_i.h   |  18 +
 net/mac80211/mlme.c          | 165 ++++++++
 net/mac80211/rx.c            |  29 ++
 net/mac80211/sta_info.c      |   7 +
 net/mac80211/sta_info.h      |  21 +
 net/mac80211/trace.h         |  24 ++
 net/mac80211/wme.c           |  47 +++
 net/wireless/nl80211.c       | 730 +++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  17 +
 net/wireless/trace.h         |  20 +
 16 files changed, 1691 insertions(+)

base-commit: a4190accbf7e05496754004bb701fb3e7d04e57f
-- 
2.34.1

