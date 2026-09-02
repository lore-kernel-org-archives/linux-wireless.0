Received: from outbound.ms.icloud.com (ms-2001g-snip4-3.eps.apple.com [57.103.73.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA8337EFE5
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 19:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.73.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377106; cv=none; b=lPDQMNOo3S95gwQTLYsaVgk6hxiZo1RRbNvO1aVa/IExlFb+pcUlyI7rAzygI+tGZIIyrGfHzRqulrt7Dt9mZwvVnWpxk/zHJUUd12OCozjCiIur/WS4etmtWiKZ0yNk6DRbLtj1/+nxfhqeAdijr3RpKcc6OxREsoDA1EoYTAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377106; c=relaxed/simple;
	bh=e3AXeTDAakJcsiVVMvMS+zeAlAQF25eLuFQcTY2lfyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExGMi1r5xLi4zEFUMI9xhhQUWsZ94pCBnAO5PHcJ2404HigE2cDxNj+gWVpCj4KmpsFJeh0d+Ps0/kI24X3nfvJfA9U5rnKMWL5Pda+t6EhMZFC8MK6Pea+XX20WswKy7zIz7S36U5D+g8wxB4LAwPwa+2y2uLdssaDJEO3gLBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mugops.com; spf=pass smtp.mailfrom=mugops.com; dkim=pass (2048-bit key) header.d=mugops.com header.i=@mugops.com header.b=CWEcgLXs; arc=none smtp.client-ip=57.103.73.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mugops.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mugops.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mugops.com header.i=@mugops.com header.b="CWEcgLXs"
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-3 (Postfix) with ESMTPS id DE5441800094;
	Wed, 02 Sep 2026 19:24:57 +0000 (UTC)
X-ICL-RepId: 01a06394-e668-79e1-a582-8a7869737745
X-ICL-Out-Info: HUtFAUMHWwJACUgATUQeDx5WFlZNRAJCTQhKB0MDXxxBAEAdVQFLVxQEEFoJUgQcA0wVWi1aHlUfSQsdDlgGEhZdRV4YUARCAxcbXAAXGVFNAFhbCFsEDx9MDFECQgVWXlQLHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBVGClgbQV5aF15NWgJWTQVKA18BWwtAC0kKXwNYBl4MTARdDkYDXVERVwhYRUEFVBFzAEIMXQBKVlACWlUSBEAIVlBUHkEEVhVsCVgGUxlX
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mugops.com; s=sig1; t=1788377099; x=1790969099; bh=b+6mMqk72i3IqBbyzasvIE1PN5hqfgK2rmiL6g8PCL8=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=CWEcgLXs3eX96tGNCgRVqbFniR1I1PW0H6R1pNak75fH5PJddlRm8r76JdkTDAAdHl8/Dynsgdu9DlaCC73dHpcROAcM8q9L+GM26+yOuZlwYQ+cdsB8U0objJ+yhMJAB+tpWG7IJGYZ5etO4wi790wPIhLaoYnamerf6w5hEGuFumJ5nBktCnfPWLIx5LFEjwl4iqSQsGfE+3CmYDmU/AJ9cbyrPluqR57r21pDu/8so5Dbc53CO9Wq2WRWH7IWFs5xAB88Xt0r9dJpRhb4E+d1yqvIl4q+oJEEzcLOu/68nilyS+0p0Bbsx1E8nmXeMat7z7ZDdhJq1YtVcAJLnQ==
mail-alias-created-date: 1773467597841
Received: from localhost.localdomain (unknown [17.156.208.39])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-3 (Postfix) with ESMTPSA id 0FC2918001CD;
	Wed, 02 Sep 2026 19:24:55 +0000 (UTC)
From: Hideo Sumi <hideo.sumi@mugops.com>
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Cc: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>,
	Jeff Johnson <jjohnson@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	linux-remoteproc@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: IPQ5332 multipd: missing text PD level and qcom,rproc ownership
Date: Thu,  3 Sep 2026 04:24:34 +0900
Message-ID: <20260902192434.54709-1-hideo.sumi@mugops.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <741d7c3e-6eea-4a84-bf4c-8d8eb8032c83@oss.qualcomm.com>
References: <20260902041339.7665-1-hideo.sumi@mugops.com> <741d7c3e-6eea-4a84-bf4c-8d8eb8032c83@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: _Ns5vuQcRycmLeXLisdYlZU-vTcZXs_P
X-Proofpoint-ORIG-GUID: _Ns5vuQcRycmLeXLisdYlZU-vTcZXs_P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX9Zg0CzUgTbhS
 X0tWzZ9uF4bqE1ugHPMfSaVDBKBhKrdN62w8nD2QgckpxlGgTLGjYM0ATqAi5MSgKCP6CTXslmQ
 fDqZOdoauhltM4PIBJwIUGz8Qnyw7pnWGeLqu5ZQ+JXzkK3AhrzI7OUDE46oIJZoja4mP8OMFAQ
 aWG6/MdY5rePHjJ54WHzwXJXE5aTKZCPfvu3jjFi7pNOTBUzosTHFShFR9zcpgTOxnWA/OLbtUl
 EFqZa8TpbkmSvQSw1U00INXpMKaFAWjflLNwiONGyT2d3WQuiOCehU2WG8m7xlXTfnbWS5PtCgZ
 cfPgLQXI8iXipZXCVeP5TabkG2PY3MsOvzOrGScPXfClJ7vdsyU8RQG7pmvxtA=
X-Authority-Info-Out: v=2.4 cv=KPNXzVFo c=1 sm=1 tr=0 ts=6a98780a
 cx=c_apl:c_pps:t_out a=kRaGL2Q7qLiahLf3O6OaIA==:117
 a=kRaGL2Q7qLiahLf3O6OaIA==:17 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=9CxBhvkm92iu2lGNyDgA:9
X-JNJ: AAAAAAABMdtZLPw0Wn1LZ/UHo2tWK49/oG2Gz0bC3HqFskj1AkZfB+1WURg2/acql3IkxXLdz/0yXnofbQLiHKq6jBEyAGulYebFT/KssOT5ibvEJ6WhppUpKvOgvmS05bS3okl1495W9kkJm0z0ga4hCvU/xvZ9ROX+okElc+9KaZRQsYuIMJckPtykHCDgtaV8NhS/opsEgh4ey01IVe/kmZXlc4Yq3a6o7PTovXZ3s7GmFHMmKhvj6Aq/L7T9IAINApc0+nxjFP22VGJrGpydCFWB7svq8f/p1PyPG+lFuaNFXIBB+oIqBUrHtq3HEjg19wLYmOFU5iqCgXMZL+KBo9GXiGUs3RDHUtD27sHfz93a8XmZfp7TpJb9nB/1qrXlaoz9tP0GPtQu2hKE0Vz+uUVX5meqfY+7z4j2IrPmRsemHrNhN06Pb0ltKrCeaMrR7yZc0bVbUK1Mk2zmSv2Exucbzd2opXIpwBTlCm8QdnRIhNIdLN9u4aszhVSyVvFKo933qS/ih8Dt+ukvAdjvpdi5Ixw/1R+JD3T6++VeQThftmD5GBPyasaL2LEQmVVs3CnUy/pQrxKZVuUZ0VHYtYMyHO/oGMeEI7+dgt08KKxtUOum1llC3dosVKgXiztCxGaQj0dkACX1Xf72HgEOtlBbjCv9mwAZZvctDBjHBX7x4kCP2Shhy7briXtl+umVxlWUSExFjwEKN/c3gJcLNH5Z3gN9x6HyE8HjEfMKDP66wwruzeHmC8+uXWgML7oEbNFAVvDDfpdoxT1JGMxDGRyVOROO5JdOFN9XCWBFeFn/4t2ZirpQOtrucCGRZyKj7F5htefBoBo1cEEq6Yd+Nag2cr5cQXAQpmTMTgJ5wpYx0Gkx6Foe2dzHwgkMpWW3BEIGQQ/6gNTstwEYbcgAe2OWHzFhHBYS/LZ8Y6bTZl6jCidC05ezROPlICbKZpSZcktcxqyaIa3LhLXv8tdTe4W+t/E
 CRuE6aUG1C3bHkltZf8IeLUDaTspu65TMHtkljXjMMNukR2vcNk2waK1hsJJaW6NA5ZvxsqYvsdxTR+JY8SkJMJHkDnlpP2rAM3g6/8/c17J7J29GvXvIG5dHGdS/oqUdEak8RYe3jdcGHRRTumHE/ghShBbuuMIezi++CD1ZiIlF1afhOACU5vd0sC8p8t1CKgBHLTs6pFXksONo0WBWtpVX+xaqLWyHcoryBU/AnZZtJqIpeuB7Co+gvBR1XP5tlcxILcQxkKzo/0+tmi4Nt5qEBIyCUHR6qyRQqp1/1IVqNcS47I9SiQvKlVVvMr6ohd++YIG8y6gdoXlDu8Nlh+qHPP/ZTcXa4q7oeKa4pA==

On 9/2/2026 7:47 PM, Aaradhana Sahu wrote:
> The intended model is that the root PD is completely managed by
> qcom_q6v5_mpd, while the Text PD and WiFi User PDs are managed by ath12k.
> ...
> So, qcom,rproc in the ath12k DT is expected to point to the root PD.

Thank you, that settles both questions, and the shared firmware patch is
exactly the piece I was missing. I built the model you describe and ran it
on the board. It gets a good way in and then stops, and the last problem
does not look like something a board can fix, so I am reporting what I
found rather than guessing at it.

What I built, on 6.18.44 with backports 7.2:

  - ath12k loads the shared read-only image itself, your patch [1] ported
    to this tree (it predates the common/Wi-Fi 7 split, so the mapping
    comes from power_up() rather than from rproc_info)
  - the text PD node is gone from the DT
  - the user PD nodes are gone from the DT, so qcom_q6v5_mpd does not
    instantiate them
  - qcom,rproc points at the root PD

Three things came up on the way. The first two are, I think, plain bugs;
I have patches for both and will send them separately if you agree.

1. ath12k subscribes to the SSR notifier by rproc->name
   --------------------------------------------------

ath12k_ahb_register_rproc_notifier() does

  qcom_register_ssr_notifier(ab_ahb->tgt_rproc->name, &ab_ahb->root_pd_nb);

but that lookup is keyed by the SSR name a driver passes to
qcom_add_ssr_subdev(), not by rproc->name. qcom_q6v5_mpd registers
"q6wcss" -- the same short name qcom_q6v5_wcss.c uses -- while rproc->name
is the DT node name, "d100000.remoteproc" here. So the notifier registers
against a name nothing signals:

  remoteproc remoteproc0: remote processor d100000.remoteproc is now up
  ath12k_ahb c000000.wifi: RootPD ready wait timed out
  ath12k_ahb c000000.wifi: probe with driver ath12k_ahb failed: -110

Subscribing with "q6wcss" fixes it.

2. wifi0's memory-region[0] does not contain the images
   ---------------------------------------------------

ipq5332.dtsi points it at q6_ipq5332_data. The shared read-only image and
the user PD images link below that:

  q6_fw3 (shared RO)   0x4aefd000 - 0x4b296000
  q6_fw1 (pd1)         0x4b2a3000 - 0x4b55b000
  q6_ipq5332_data      0x4bd00000 - 0x4ca00000
  q6_region            0x4a900000 - 0x4ca00000

so qcom_mdt_load() refuses them:

  ath12k_ahb c000000.wifi: segment outside memory range
  ath12k_ahb c000000.wifi: failed to load shared firmware: -22

Pointing memory-region[0] at q6_region loads both. If ath12k is to own
these images, the region it loads them into has to be the one they are
linked for, and on this SoC that is the root PD's window.

3. The user PD nodes: removing them is what the model requires, and
   also what breaks it
   ---------------------------------------------------------------

This is the one I cannot resolve from here.

Leaving pd-1/pd-2 in the DT does reproduce the IRQ conflict, exactly as
you said:

  genirq: Flags mismatch irq 31. 00002001 (UserPD1-spawn)
          vs. 00002001 (q6v5_wcss_userpd1_spawn-ack)
  ath12k_ahb c000000.wifi: Request spawn irq failed: -16

Removing them clears that. But the root PD then stops during its own boot.
Its crash record says:

  pd_stubs.c:137  Invalid user-pd CS load address 0x0
  Thread name : sys_m_smsm   Process name : kernel
  PC : 0xc000ae58  SSR : 0x018f0027  BADVA : 0x00000000

and ath12k ends at "UserPD spawn wait timed out", probe -110.

The address it is missing comes from SMEM item 507, written by
qcom_q6v5_mpd's share_upd_bootinfo_to_q6() before the root PD is started:

  list_for_each_entry(upd_rproc, &upd_rproc_list, node) {
          upd_bootinfo.pid       = upd_wcss->pd_asid + 1;
          upd_bootinfo.bootaddr  = rproc_get_boot_addr(upd_rproc, fw);
          upd_bootinfo.data_size = qcom_mdt_get_size(fw);
  }

upd_rproc_list holds the user PD rprocs qcom_q6v5_mpd created. With the
user PD nodes removed it is empty, so nothing is published and the root PD
faults on a zero address. With them present, remoteproc owns the spawn
interrupt. As it stands the two requirements exclude each other.

So my question is: in the intended model, who publishes the user PD boot
info to SMEM 507? Three shapes seem possible and I did not want to pick
one blind:

  - ath12k writes it, since it owns the images and knows their addresses.
    That would mean moving share_upd_bootinfo_to_q6() out of remoteproc,
    or exporting it.
  - qcom_q6v5_mpd keeps writing it, reading the user PD nodes for their
    firmware-name but not creating rprocs for them. The nodes would stay
    in the DT and describe the PDs without claiming them.
  - Something else covers it that I have not found -- the shared firmware
    patch does not touch SMEM 507, so if there is a companion change I
    have missed it.

I do not think [1] alone is enough to boot this without one of those, but
I may well be reading the wrong tree; if this is fixed in ath12k-ng or in
a series I have not seen, that is a fine answer and I will go and read it.

For reference: reading the Q6's crash record needed a change of its own.
q6v5_fatal_interrupt() calls

  qcom_smem_get(QCOM_SMEM_HOST_ANY, q6v5->crash_reason, &len);

and QCOM_SMEM_HOST_ANY is -1, so smem.c only searches the global
partition. On this part the record is in the WCSS private partition, host
1, and qcom_q6v5_mpd already defines WCSS_SMEM_HOST as 1 for it without
using it, because qcom_q6v5_init() has no way to pass a host through.
Until I read it from host 1 every one of these failures printed only
"fatal error without message". I am happy to send that as a patch too if
it is wanted.

Board is on a serial console with a recoverable second firmware bank, so I
can test whatever is useful.

[1] https://lore.kernel.org/linux-wireless/20260811054316.518494-1-aaradhana.sahu@oss.qualcomm.com/

Regards,
Hideo Sumi
