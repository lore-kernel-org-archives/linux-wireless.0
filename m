Received: from outbound.ms.icloud.com (ms-2002g-snip4-11.eps.apple.com [57.103.74.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF73B4AA56E
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 12:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.74.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439390; cv=none; b=FJa2gzcPhYxk33NOQJ7W7mPscW4DIRVedNLObUJn+lrFwAY21/hVYtejki8PvFksz1FnOKJZ17CUuPGF9ZK3BUG5MXv8X2EvKwYD6V14YDiLkX/PG/+OVFhi6ZTrfcw+aZme7erUf2PyEO6UcA5+3/qpg7ISioJB4avaASVUUtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439390; c=relaxed/simple;
	bh=DOCuQ4V0ymN1NKV54jkjinTJeafVjP35V9w6RCsvWOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFr3OhCzSucOqsvtgnCdqOtqObYm5fKXrifSXGn/etrVCYuu7L0auRn0/+CiRBvaSLn82+PeI2i/L8X3WttHml95pdOyEW/j17T100pAr4XA+Tt4NglfjAecLjIeIevVp/1Hvk2y1QmHyLlypynDU/TRBlw7DsLzCZCNC1XFj70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mugops.com; spf=pass smtp.mailfrom=mugops.com; dkim=pass (2048-bit key) header.d=mugops.com header.i=@mugops.com header.b=qha+5i3C; arc=none smtp.client-ip=57.103.74.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mugops.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mugops.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mugops.com header.i=@mugops.com header.b="qha+5i3C"
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-7 (Postfix) with ESMTPS id EA1451800127;
	Thu, 03 Sep 2026 12:43:04 +0000 (UTC)
X-ICL-RepId: 01a0674b-5353-7c1d-9f0a-ac4a131db511
X-ICL-Out-Info: HUtFAUMHWwJACUgATUQeDx5WFlZNRAJCTQhKB0MDXxxBAEAdVQFLVxQEEFoJUgQcA0wVWi1aHlUfSQsdDlgGEhZdRV4YUARCAxcbXAAXGVFNCEgTBVIHXU1WDUcPWB5cFBcVQENeCF4fTBwdDlgGEgBNCg42BlkFXglWA0MFNhIUXUVeGFAEQgMXG1wAFwZbFAREAV0FXQJJCUsCXwNZAUgXTQpUB1MfQRQQWglSBBwDTBVaLVoeVR9JCx0OWAYMUE0BQwgKCEcDTRdeMlMEXxFQFg==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mugops.com; s=sig1; t=1788439385; x=1791031385; bh=3kGf9SwZXN+BBQTc+zQUIoGFVBNm5rRQNe5woeRka4Q=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=qha+5i3ClmSF7Fxs1Rj6X46tU2Ss4oZeXDh3TKlY4L7bATgk5c8ZBY4ThVNpalo7Gn6lQSNJ9yg4pQS5xMNYmdxr2b+8YUCqUQSbDywF2EBVHeMP3YZNFSyC3mYACB8buQUAUzpjZVbejXvPrAsDVLMFNnmGMeNvV2a50nSV4JydwxyhmKVpz52svsy7CSgRoMDMkiwFZ0usgUrj2xGJeQEzcPGRuUV9KuUbwLjYdZAwEhvFuwpbvzHKYi4z7JLtngQ0698WYtHiINzHWAjCOYDT2BCVK4rf3yJFyor3C/D/V71CG/nnqVqEKMO8g7MAmTZ0nUOTQE9aD/90bEtIzg==
mail-alias-created-date: 1773467597841
Received: from localhost.localdomain (unknown [17.156.208.39])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-7 (Postfix) with ESMTPSA id 1E9501800347;
	Thu, 03 Sep 2026 12:43:03 +0000 (UTC)
From: Hideo Sumi <hideo.sumi@mugops.com>
To: aaradhana.sahu@oss.qualcomm.com
Cc: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>,
	Jeff Johnson <jjohnson@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	linux-remoteproc@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	Hideo Sumi <hideo.sumi@mugops.com>
Subject: Re: IPQ5332 multipd: missing text PD level and qcom,rproc ownership
Date: Thu,  3 Sep 2026 21:42:38 +0900
Message-ID: <20260903124238.59908-1-hideo.sumi@mugops.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <9103ca95-5e27-4979-994c-e14f123cec7e@oss.qualcomm.com>
References: <20260902041339.7665-1-hideo.sumi@mugops.com> <741d7c3e-6eea-4a84-bf4c-8d8eb8032c83@oss.qualcomm.com> <20260902192434.54709-1-hideo.sumi@mugops.com> <9103ca95-5e27-4979-994c-e14f123cec7e@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDExMCBTYWx0ZWRfX9Byj5Hr75JY/
 okKGDzwSJLaZBjADxkP0r1HYQQvnycqOLAtPR4EkgW5H+x0eskkzm9arkhNmTEQPgEIi79GX+r0
 yBV5T4JHdAdN8aww+mF9BuSwfpss+i9oEQ6XD9hD8qIcuS69QL2JIIzC+XXYpbeooUQUjJrvhid
 EBqQi8s1htGMC+raDg240mhJyQ1sKCwKVGIdVeEPiLW8aoeFrelFf+NFu33ayCv6/M7TjdNOjxy
 9kGE3f3U9L1p9/+OK+0CHeykqKtJ2ur5oWmt4OwLKgcyYiUJuxyNKjMwqiGRP9NxCDzeM2VAAR8
 gqPq+EVyBjN7tDwPCidlRuMCb6bhhVAB6VeavWyTNkrLQdLZYY2NP6867I+drI=
X-Proofpoint-ORIG-GUID: fJGpXCPCm4865Lp24sjlw02uyE5evvgb
X-Authority-Info-Out: v=2.4 cv=JpD8bc4C c=1 sm=1 tr=0 ts=6a996b59
 cx=c_apl:c_pps:t_out a=kRaGL2Q7qLiahLf3O6OaIA==:117
 a=kRaGL2Q7qLiahLf3O6OaIA==:17 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=DQ8r9CIClS4u8aE-f4MA:9
X-Proofpoint-GUID: fJGpXCPCm4865Lp24sjlw02uyE5evvgb
X-JNJ: AAAAAAABsVGxVvdrxWYo/wJ3mE214TkUdo81P/0LhmPGT57FjVoK77pnffZRUt+mi1OEsSGLHtBB4AiYWtxRCOhDhj61iwj8jHGZrpOKx69uf5WiI8As1c4pvRup3X9vPOrFKAaa3UHm/QCbdqueglTFCSD+E6zfwYT8G5RbYA2+p5QI4mDkwHv34JyGGhRmlvYxh7wxSXIGDeRTIhkdI3sxlDmAqNAAQnnwvRzG/wcpwMXGONqHBqOFEJhNX35MVFVmCwErPJJJmC4NqEe+J+qJ6rkOxhyon3e4qGiznGqFW0pHVexTNNkAMaNRVpn8dbRc8qCabX2SotGLxZc/pXuntl+KeW5JLR1fRsBvIJFEpuIoz8pPs31QC5bxmuDxPAYyxcVK8GZARbIYtEdm7qAx17nc1VWs26r06SonnxEVhxDKo/SnOzTs6dD7n2+ZtwA7wrzFvDgC4xBnT07+CuJ6FnI1ISx3vYZX9SMAG/KeJiYae2ujp8X5vcqwzAdQ2dO1f8ilkCrv6BoP8WHALFoXVA4sthBEOmh46uC3B0tbrUpqqYN79RYb2q2XdP2cLQcQpNf+NMLPUOuH6w7ECebl4isSxqzZbQtJIOtO2icXJxRgkYRgK1zI4It8kdwcwsB7f+/HsTSbZFQThnislVz1/GUaiTj16G7t3tPT4usOVCOPUrY5L00sn+Gf3OlprUSIGj1v2BdpB6Lau9wj/5FcjxPeJ7QykGFz+ytqyp83LHontzY4ndG/NJqmG7uphWYNm0R8pT74FqURJy2VOdRw1DMDXulrD3lQUyuqsN7PQjDwrlsEnj7Uzr4eVoNni/+Mt62IkmeGeoA4Mo3NfGJjDmsM6hznosx02HooIwN1sduuAffS7SFMrcvQ/D0lq9rf20stZf3ApHzgvSUj+8tDQCDPPUq4CURygkpVSucvRZ3uZ5cSO39vx46IhTJx9YNnYhXioThcOAki9FT1un+Mnv24VAN
 0GX+hW8omDewbncqIYSPKzfK/Cx6DtKP4lBnxb9LuDUNLYGca9600gbik8O03Z/hmIZxrkLrOAOrWcZXI+7yo18qH5PXd1NSpXAtyBq8ozMFvegnSSnfz+cPG4OEKrBigFnf4dIX0Rj8CxBGaVAYk75uX3GzWRieHMp8/Y+7hnzGNS6/09Xu89LqttubOnG6hZIE42vTbgD4n3C/MmkXZWjAvnw8XlyeEbyzpQjQnzBieAVHyRXTaBpuESsQgK53xbDkiNhPgql95iOT6vtXnnk4ponSaA0MlZ/0avWv2ghE8vphiTRo7MTA+EW8KvXbiE1qJnNPBp04eQlxXoYU=

On 9/3/2026, Aaradhana Sahu wrote:
> Before we look into the SMEM handling, could you please confirm whether
> you are using the latest ath.git ToT and whether the remoteproc v14
> series is included?

No on both counts, and thank you for the pointer -- I had not seen v14.
Let me be precise about the base so we compare like for like, and then
ask you the one question that would settle most of this.

This is an OpenWrt build, not ath.git ToT:

  - kernel 6.18.44
  - ath12k from the OpenWrt "backports-6.18.39" package
  - the multipd remoteproc support is the *old* series: Manikanta
    Mylavarapu's original multipd patches (Nov 2023) plus Ziyang Huang's
    "split q6_wcss to rootpd and userpd" fixes (Sep 2024), carried as
    OpenWrt target patches.

It does not include your v14 series. So it is very possible the issues I
raised are already addressed there, and I do not want to send you
chasing a three-year-old base.

The core of my first mail was a *text PD* level between the root PD and
the user PDs, which the vendor firmware for this part requires and which
the 2023/2024 series does not model, so I added it locally:

  q6v5_wcss   qcom,ipq5332-q6-mpd         q6_fw0.mdt   root PD
    text-pd   qcom,ipq5332-mpd-upd-text   q6_fw3.mdt   shared RO text
      pd1                                 q6_fw1.mdt   user PD
      pd2                                 q6_fw2.mdt   user PD

So the question that would settle it: does the v14 series introduce this
text-PD level (a shared read-only text image loaded between root and
user PDs)? If it does, my local patch is redundant and the right move is
simply to use v14 -- no need to debug the old base at all. You wrote the
series, so you can answer that far faster than I can by porting it.

I am glad to help validate v14 on this hardware if that is useful -- if
you can point me at the base it is meant to apply on (ath.git ToT plus
the series, or a branch), I will build it for IPQ5332 and report what
reproduces. I would just rather not promise a blind full rebase, since
2.4 GHz already works here on the old base and I do not want to trade a
working setup for guesswork. The OpenWrt device support proceeds on the
current base regardless; the upstream question is only about landing on
your track correctly.

The details you asked for, in any case:

Firmware version, from the Q6 error record:

  WLAN.WBE.1.3.2-00067-QCAHKSWPL_SILICONZ-1.128291.1.135427.1

Platform: Qualcomm IPQ5332 (Xiaomi BE3600 Pro). Two on-chip WiFi
devices, two user PDs, both attached to the single Q6 root PD via the
shared text PD:

  - wifi0 / pd1: on-chip QCA5332, 2.4 GHz, AHB
  - wifi1 / pd2: QCN6432, 5 GHz

The multipd DT (our downstream form on the old base):

  &q6v5_wcss {
      firmware-name = "ath12k/IPQ5332/hw1.0/q6_fw0.mdt",
                      "ath12k/IPQ5332/hw1.0/iu_fw.mdt",
                      "ath12k/QCN6432/hw1.0/iu_fw.mdt";
      status = "okay";

      text-pd3 {
          compatible = "qcom,ipq5332-mpd-upd-text";
          firmware-name = "ath12k/IPQ5332/hw1.0/q6_fw3.mdt";

          pd1 {  /* wifi0, 2.4 GHz */
              firmware-name = "ath12k/IPQ5332/hw1.0/q6_fw1.mdt";
              interrupts-extended =
                  <&wcss_smp2p_in 8 IRQ_TYPE_NONE>,
                  <&wcss_smp2p_in 9 IRQ_TYPE_NONE>,
                  <&wcss_smp2p_in 12 IRQ_TYPE_NONE>,
                  <&wcss_smp2p_in 11 IRQ_TYPE_NONE>;
              interrupt-names = "fatal", "ready",
                                "spawn-ack", "stop-ack";
              qcom,smem-states = <&wcss_smp2p_out 8>,
                                 <&wcss_smp2p_out 9>,
                                 <&wcss_smp2p_out 10>;
              qcom,smem-state-names = "shutdown", "stop", "spawn";
          };

          pd2 {  /* wifi1, 5 GHz */
              firmware-name = "ath12k/IPQ5332/hw1.0/q6_fw2.mdt";
              interrupts-extended =
                  <&wcss_smp2p_in 16 IRQ_TYPE_NONE>,
                  <&wcss_smp2p_in 17 IRQ_TYPE_NONE>,
                  <&wcss_smp2p_in 20 IRQ_TYPE_NONE>,
                  <&wcss_smp2p_in 19 IRQ_TYPE_NONE>;
              interrupt-names = "fatal", "ready",
                                "spawn-ack", "stop-ack";
              qcom,smem-states = <&wcss_smp2p_out 16>,
                                 <&wcss_smp2p_out 17>,
                                 <&wcss_smp2p_out 18>;
              qcom,smem-state-names = "shutdown", "stop", "spawn";
          };
      };
  };

  &wifi0 { qcom,rproc = <&wcss_upd1>; status = "okay"; };  /* pd1 */
  &wifi1 { qcom,rproc = <&wcss_upd2>; status = "okay"; };  /* pd2 */

Thanks,
Hideo
