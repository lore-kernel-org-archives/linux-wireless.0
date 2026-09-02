Received: from outbound.mr.icloud.com (mr-2002f-snip4-4.eps.apple.com [57.103.68.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9192730AD1A
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 04:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.68.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788322461; cv=none; b=b4cZcMbnvIDPrys6zvfl56GOQBbe42YTUZF59OVT3PyhdfMucwljka2ic5H5RCKFUumk9rA8ahi2uar1Lnm6aKLWxExvUB/617tzLSo/aa0gWP7IiUXf2z6mJUEyeyNCRP880C7HCjFjvdxd8JQVmld1AZnWQ4GQmkdnXHlziv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788322461; c=relaxed/simple;
	bh=ymerjc2ZZeZpVB3H/xBuFEeF15PcKTSyoAHc8LSsCj8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iH/ihmU2xlfCHmnmHnUlchiXT/1D/ircPaQ3SwPspvyPpnkTUTifXC7lurxCKEsGPk/OVbnp/hsEH3soSbpKJlPJ0rk5A4PeGn5C4uDwTjBuZxBbupF5cSoeh3X8jtSOdERMnbQ85Oy4+AVn/07F1msbGO5yzgDvAB5IFmRWgBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mugops.com; spf=pass smtp.mailfrom=mugops.com; dkim=pass (2048-bit key) header.d=mugops.com header.i=@mugops.com header.b=QhTqjz+a; arc=none smtp.client-ip=57.103.68.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mugops.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mugops.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mugops.com header.i=@mugops.com header.b="QhTqjz+a"
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-9 (Postfix) with ESMTPS id 6DD5A1800105;
	Wed, 02 Sep 2026 04:14:16 +0000 (UTC)
X-ICL-RepId: 01a06053-230f-77a1-a2d5-4ca82b34aedb
X-ICL-Out-Info: HUtFAUMHWwJACUgBTUQeDx5WFlZNRAJCTQhKB0MDXxxBAEAdVQFLVxQEEFoJUgQcA0wVWi1aHlUfSQsdDlgGEhZdRV4YUARCAxcbXAAXGVFNAVhbCFsEDx9MDFECQgVWXlQKHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBVGClgbQV5aF15NWgJWTQVKA18BWwtAC0gHXARYC14OTgVYGlofGFAcVgIZGEcdUDheGFAEQgMXG1wACUtGCUkdDg5CGEYfVCdXAloKWx4=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mugops.com; s=sig1; t=1788322459; x=1790914459; bh=P8bTnWEyJUxXVkFvR/GQLqNyBTi2JLeqpEghmiKgmik=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=QhTqjz+a5OIxf1uXj0MzdfI3OhbmiDos+yboZcNjoKDSoyzWzKZZMpA9FTviOk5fDXeRGnLWpzEZRP4zDHstrYBcSpdXjDCjKHwfqIt8YiuRhF/ywYeH5pZUNNKCRMETKtaDik7FcAfbO/LalxiCH3XkEcdR3n/l1GBzYRtyLzZRKztHWvqSY36U7/yg37B7eCvUx2eMBvuI5z4HH1/hfIIfBxpgb5xBoz1+M7+qbxy9GaM75Q3ZaXhYN4Ad9iXigq+S2p/oQDbH0+qBOc5VVSPNF73nNmMdaWcPD8nrGtKckF4BzzjeN+kguFJCK3asHtrKMNS530oS1Sa747RpjA==
mail-alias-created-date: 1773467597841
Received: from localhost.localdomain (unknown [17.156.200.36])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-9 (Postfix) with ESMTPSA id 5B836180014F;
	Wed, 02 Sep 2026 04:14:14 +0000 (UTC)
From: Hideo Sumi <hideo.sumi@mugops.com>
To: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>
Cc: Jeff Johnson <jjohnson@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	linux-remoteproc@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: IPQ5332 multipd: missing text PD level and qcom,rproc ownership
Date: Wed,  2 Sep 2026 13:13:37 +0900
Message-ID: <20260902041339.7665-1-hideo.sumi@mugops.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: MF4VUnUysPfHYYGpCoEx83kFLF4BZ9nG
X-Proofpoint-ORIG-GUID: MF4VUnUysPfHYYGpCoEx83kFLF4BZ9nG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDAzNSBTYWx0ZWRfX7n6qUbazuRZl
 +L+8OD54ht7f6JQy6WEzJtx5RTIKXwy7SVhuRYQweVAlLf7Z3oWmPJn0NdU1a0VqgDaaIfeuQGz
 h+4GGtaWuWwMVyFQBP3AcqQ0p7bsPAykRIlaTpRdgYJa9in4vkAE4YSQvd/p2srcoBKTUWyQLb+
 Oo/X8qECti3ppUGdXMmXAF2jzg858KfkaoQeLKRsweQxiPeoKIEBQfcX+GWetd3Yjo2Zp69/s63
 Rmdsd+A3e6cELdblXSEM0cLXJ6F9Gi/j2qMIP4XseTexehAIOJSpyvdnTHWKGNbrggAPbiisVPL
 vaYTa1h7nn9Q7i/ypGifMqzTpYSg5E1wt/JW92OK/NXb0KPCBQ37UBa9EA1RLA=
X-Authority-Info-Out: v=2.4 cv=cNvtc1eN c=1 sm=1 tr=0 ts=6a97a299
 cx=c_apl:c_pps:t_out a=9mRn2PO/+PIrVdEbaIuMPg==:117
 a=9mRn2PO/+PIrVdEbaIuMPg==:17 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=_vlfWRWgPTq3-XICB4gA:9
X-JNJ: AAAAAAAB9YZqR8kp5r5nOFOn+L6opk//pkNHto4NurxhPhL4HzjX3OPidzx+ODGkCRBvivBhZo9SDbcwvx5OhykJQ+220XH7S3pGPAro/hlAThibpKjGOaVEUrSwV5jEq3q/H96f+8CvkwlrIQHZbEEKfeA4Y5dZ9whtX/ensqnSc5Bf49zfkbLLz0GxXz1QJkoStb2Rrc0wXlMOBE9Pno441pKeDiD5ZDffdb63IALuKhMLOtlXOS702wuAEezPrHXRoBbfurhaOBKzoWKEQ2WGnq63+lgbhyoSPlAoKG+4G/GWRNkLhPL9XGXgYfoK7HKF4ErV7ZLkacsdBg/SSGkAZht46q/U6ib1vs29YqgiFRvNqpwptG2tY2DppPYTyp9UyoeJG22ILqngy4SEiDBXBtGSChHHM+ayBjbl7OQDqeBfHNEm5ngxt5iQhFwRhvqak08T6mIqCBq9vTatFLXFGk7D/RxQbH1kE50HSB8XOrkW3+mgu6cT/CjP0GoK+iu3CgHQEKmAzmF5u3JtRphUqcTRFhvuzZCnstRx3ONe5uCWaDoQVeXqSxr3HP6v4VwiYEAPiIJxTajwkPQQQJH7vBedHlHLzm/GWYohEWjjbPKe/L96DHRpKm4luSyw0zH51hon6ULXyNwOzZb8EHZZfNbpi9DQi3xDeH+Girq3TBqk4crUjzch+pIlRHDKvDgWUtZN3R5AdDDY/Pm2xKbLV2nVSm12zBrCNMA31ClwpBEJambZtrsaToXbzi4gP2wVUWy7UUXLwMaUfZ7osNB/zot+Xgdm4wCIo/2w26lH6EPQCtdOW+cqrFgtyTsjZDX+c6FQ16fvh8wBO4gMnnpZul8KlCW6D0InkPUDGxSyZ+XWyImypA/oVE3fvoQ4raaMRTXAM2Gn4TNP1jpV5mOlILItvEOVLAOno85ejxXTeX7Dhz7NVa2rZKVWCnUe0SwGIWM4JLP911yUmQpSO1DC5IDLpIL
 8rH0pxgk1JX33bp+u5k+BrOYH8Gk18p/wrYMnANLbV2Id90u017X/SYihtIHmwXnpjgZUgUip8BwuP8SFQN2tkWpZrK4/YhnzFdi562Un+EOgGECmx6XHF8fDOoPrMpMhHOLObOJ1Zn+9uALju6Kbx4Eykd3SU6rMR533TzmASLQKiZYfaCHyPWCjdNQhovDUnXWKk+5bxj/qQg+PoIuG1RIhbnZqyxRKTnnhfdo2h2sJXlgZSKBW6ODNVPY0lIEB9Z2lRVfd0UwZwXET7L/AzKM=

Hi Manikanta, all,

I have been bringing up the WiFi subsystem on an IPQ5332 board using the
multipd remoteproc driver (qcom_q6v5_mpd) together with the ath12k AHB
backend, on 6.18.44. Two things came out of it that I could not settle
from the code alone. Both look structural rather than like mistakes on
my side, so I would rather report them than sit on them.

Caveat up front: I am running vendor (QSDK) Q6 firmware, as there is no
upstream firmware for this part. If either answer is "that is a
vendor-firmware-only concern", that is a perfectly good answer and I
will stop there.


1. The root PD does not boot without a text PD level, and the binding
   has no way to describe one
   ------------------------------------------------------------------

With the DT shaped as the binding describes -- a root PD with user PDs
pd-1/pd-2 directly underneath -- the root PD never reaches a usable
state:

  qcom-q6-mpd d100000.remoteproc: fatal error without message

No further diagnostics, and the user PDs never come up.

The vendor DT has a level between the root PD and the user PDs: a text
PD (compatible "qcom,ipq5332-mpd-upd-text") that owns a separate
firmware image, with the user PDs as its children rather than the
root's:

  q6v5_wcss             qcom,ipq5332-q6-mpd        q6_fw0.mdt
    text-pd             qcom,ipq5332-mpd-upd-text  q6_fw3.mdt
      pd1                                          q6_fw1.mdt
      pd2                                          q6_fw2.mdt

Once I added that level -- a text PD node with its own firmware-name,
the user PDs reparented under it, and a small driver change so that
q6_register_userpd() recurses and the PAS ID is derived from the node
-- the fatal error disappeared and the whole chain came up:

  remoteproc remoteproc2: powering up pd1
  remoteproc remoteproc1: powering up text-pd3
  remoteproc remoteproc0: powering up d100000.remoteproc
  remoteproc remoteproc0: remote processor d100000.remoteproc is now up
  remoteproc remoteproc1: remote processor text-pd3 is now up
  remoteproc remoteproc2: remote processor pd1 is now up

The ordering is the interesting part. "powering up" runs child to parent
as rproc_boot() recurses upward, and "is now up" comes back parent to
child as it unwinds -- which is exactly the parent-first dependency the
multipd model exists to express. The text PD simply was not one of the
levels it can express.

So: is the text PD level deliberately out of scope upstream -- because
upstream firmware for these parts is expected to be packaged without a
separate text image, say -- or is it a level that should exist and is
not there yet?

I ask because if it is the latter, the binding as posted cannot describe
this hardware at all, and that seems worth settling before it lands. I
have a working change against qcom_q6v5_mpd.c and would be glad to send
it as an RFC. I did not want to send it uninvited if the omission is
intentional.


2. The vendor DT and the ath12k AHB backend disagree about what
   qcom,rproc points at
   ------------------------------------------------------------------

This one I can describe precisely, but I cannot tell which side is
meant to be authoritative.

In ath12k's AHB backend, qcom,rproc is the *root* PD. ahb.c resolves the
phandle and boots it via a function named ath12k_ahb_boot_root_pd(),
waits for rootpd_ready, and then does the entire user PD lifecycle
itself: qcom_mdt_load() of amss_<n>.mdt into memory-region[0],
qcom_scm_pas_auth_and_reset() with a PAS ID it computes locally, and a
spawn via qcom_smem_state_update_bits(). It also requests the "spawn",
"ready" and "stop-ack" interrupts by name to drive that sequence.

In the vendor DT, qcom,rproc is the *user* PD:

  wifi@c0000000 {
      compatible = "qcom,cnss-qca5332", "qcom,ipq5332-wifi";
      qcom,rproc = <&remoteproc_pd1>;              /* the user PD */
      qcom,userpd-subsys-name = "q6v5_wcss_userpd1";
  };

There, remoteproc owns the user PD -- image, PAS, spawn and the same
three interrupts -- and the WiFi driver only attaches to it.

These are mutually exclusive, and on this board they collide. With
qcom_q6v5_mpd instantiating user PD rprocs as its binding describes, the
PD boots fine and then ath12k cannot have the interrupt it needs:

  remoteproc remoteproc2: remote processor pd1 is now up
  genirq: Flags mismatch irq 31. 00002001 (UserPD1-spawn)
          vs. 00002001 (q6v5_wcss_userpd1_spawn-ack)
  ath12k_ahb c000000.wifi: error -EBUSY: Request spawn irq failed: -16

Same interrupt, same flags, two requesters, neither wrong in isolation.

So which is the intended division of labour?

  - Are the pd-1/pd-2 nodes in the multipd binding meant for non-WiFi
    PDs only, with WiFi user PDs left entirely to ath12k -- so a board
    with only WiFi user PDs should describe none of them, and point
    qcom,rproc at the root PD?
  - Or is remoteproc meant to own them, as the vendor DT has it, and
    ath12k's AHB backend should attach rather than load and spawn when
    qcom,rproc resolves to a user PD?

I have deliberately not sent a patch for this one. Either answer implies
a behaviour change in a driver used by boards I cannot test, and
guessing at the ownership model and then changing ath12k for everyone is
not mine to do.

Happy to test patches, provide full boot logs, or run experiments on
this board -- it is on a serial console with a recoverable second
firmware bank, so I can iterate destructively without much risk.

Thanks for the series, and for reading this far.

Regards,
Hideo Sumi
