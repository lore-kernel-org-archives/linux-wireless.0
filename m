Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4253D7A01
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 13:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764271; cv=pass; b=DaqB3/yfKDH5lWmB9nsnKeKT7hyyz+VUK7x8OTFGni8Gmwxm1vJ+qiFczJRCDwFehcMyizHQh0QnUZT51IHDoKrI5RPFPsD7PbznhQiftAlJGCVZ3Hco21FaJm1+A677crFSe4F7uAp1Jj4UMk9H0SMRPKxJ6nLECcpvQyE21vk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764271; c=relaxed/simple;
	bh=SqJe3EZPOAS+ATQtGZAzXPMXAesHd2zSQtTkzLMIy5I=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=sksmNoAnt+ZGF7TiWysMSZq4FcXwvH7Q/K123LW7sUip6+g0ikRKxkmOBnqqcWzOyrur4KjtOYuCWSM4Gzg79G5iaSRtA+aMOgdqs99m7UCLCdoHYhvgPhGzW+qvTs6suxBcTt5s7crGbRoKaBKO7kJAg5thTvpq2Zv7mjiJ4IY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GehehOqv; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GehehOqv"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c928bf172so19138681cf.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 06:37:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785764269; cv=none;
        d=google.com; s=arc-20260327;
        b=s6y1NqxaIVCl/l1VGODkDmoxDLGzRrznQGoxxFIP5hP7/j5jQYmePyWuI8oi5Mwcon
         LgvkIpFEHkpCV3YWFJi2KGz3lw+j9hnVFXs3Z/vWBF8kUc9ds/NFNU192fqiv8T/Zqno
         cL8tUyvxlbftW1YmvqgAoyAlX0En/VwnWOEsUEIZ9k8s6P//RhBHf8+0u8PxdrrmdE16
         bs5DeNeymNNXVhh4l7DfYGoqWXt6alhKD3UKXnAu+UkJOoXQz+TCN+wnXhNAeGWvgqam
         uY9VrWN/2EuSoZBr4Lo/mjdPeS757hua8r9c1u5fpyOCHWFxwO60MCHF+JoVKOzSnyvM
         2hJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=/FC6z87r+mdO33nIFcf4J/sknNa4tnocxzppMasidjc=;
        fh=BzVcj3AOSjt+4oCebDOU6fO0kGZQwBEUFf03l6Edbvw=;
        b=rN8u0kw0Bdwhf+F9i7LmDVGKYEACy+GOWKVT8LMIt9SdJb8IkJeIAu5IErTx2dFths
         QjoZJwlFpXdlc9+ELWWfQD7zqJODQHu0yNDzjfJTjoL9PAvieVIJpdUNUqdty+mMPX3Y
         0TYRvh6sDf0Pn2g55KCqmD7IUrsY25qtcmRozK1LyXYey+MRUuydFw2Jav5Vra4VMtzo
         iP0sW9Pwwe/5VH3u6D/bt+iYMvrWrC7CQYeTG72gEaGEe+hq2H2lhUgFG795otWQH8kC
         o6E7Bb9vb1WzBgQVF4Bn08eWh1QSg3tV1bRMgbk2Lb1unk52myhR1HrXN5n6A3j+E1Oa
         MQ1A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785764269; x=1786369069; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/FC6z87r+mdO33nIFcf4J/sknNa4tnocxzppMasidjc=;
        b=GehehOqv2ReAPMErDkp4JYkDdt44rMg3a6bManzsY9XWDmxh4oA0rowQPF+o99hIVg
         BphpNKTRsfXyCdyYCY66E1x44bZ3fokjGRdfNxTZQesXf50areXcXpCObX4zfcj0gXm8
         ibkEuvqsCt9ev2/Er95swYDEztiy3rv9NlPh0+fcEsI+bXFMJiMmILMa2fXWOlKPcNR2
         TXsdgbXTKoHjZjdoM2Tkih6GoN5uAfYxIjsegtSpKHeP3LyhNMbFSrganQIoF50iw4DO
         CRMpqG79JDgVcntTEV1vnSOfwSDH7xmYYGYa0Hdy9x5G8OAGuvIZbXc7VsFq/IhgiWkC
         OVVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785764269; x=1786369069;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/FC6z87r+mdO33nIFcf4J/sknNa4tnocxzppMasidjc=;
        b=d1lykP5KfVKtQhOESjxhEeUrdnD0Wkce8vs5U7ySKm3y5urUqmHFjadEYgdRpNxB4V
         7xnJYE1jssvho27WAY6hcEGQn/sFgLrjUl8W1kPbChosCHfw22/6tMNqUrXCttBBkcjh
         k5yQ4rVhTcw909F3OdwWQA8nyZBefeWacIarFkY3S5N/cjfKXihKXXW6h4+u/oPA0H2Y
         mdAWVGHY4GPYiRkwAR+Cukyd8I8OEvSp4G3+lU/sHL6OY86HYeOae+NxnTblm9Q8uyX6
         0UA9YHQmlqjgijBo7K/Hi7SJ8K4gU4OuwaDhnFsFEtRB4CaCmHbLOJKB0bUSEqRh+lQY
         Znjg==
X-Gm-Message-State: AOJu0YyzTqeilNV8a7/eJujgbYPvaL0UhcdKbF2mDId4jxREB16+KJWt
	owSV+UO7cV+VzhCXz62KtXGK8DKjpzvB4E5p/Kh0zh9SCjJ1ESZ02hr+3YlUp4QY+DQkaOe4iEh
	qRvQRROjsyjsjxSJXCoYJZlE1LMtUz4q0P7gh
X-Gm-Gg: AR+sD114jkJZF1EkTOQzpMY3RSx1Jek58/hvM85/QcpGXdssezO4NNr1NZYyEnumvj2
	Nd3NC1U8w546nsBSz4NmDj37d2evuvigp7ZbPBN1Hz1KFwITtbXchSr8FgBG4PT3T6w9O6k6VW8
	1ooW1M3SZ1IgBodjRpEbVPtjGqhtlk7uSaizJIZFDF3sAQDl4keEKVAuqT46YfbvcaspkpQ2Gvy
	rpvuXrS1/zMhxx67LRRExT7XbpLbWFNyiZJNNL6ivNKzR1IORKJ4QXksK9oh6FRgzzc/Z0JUUa8
	5qOZs2dmHBIvPZRtrv5B27TxRmOmSvGTIGFlg2iPmyyPvA==
X-Received: by 2002:a05:622a:2448:b0:50d:e471:2d1e with SMTP id
 d75a77b69052e-52b56796756mr216669591cf.35.1785764268494; Mon, 03 Aug 2026
 06:37:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Morgan Wong <pbodq2@gmail.com>
Date: Mon, 3 Aug 2026 21:37:37 +0800
X-Gm-Features: AUfX_my52F_WsXUNKO17EPdt6_bQ37R_zLDjYZWy1NX8Nrq8o2XftkK-hFIQ_Ms
Message-ID: <CABzKGg0YEm5PfW9YtEM0G1SYY6RD80DmFpu_Jpb9hoioK+tH-w@mail.gmail.com>
Subject: wireless-regdb: Update regulatory rules for Hong Kong (HK) on 5GHz
 and 6GHz
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Dear all,

Currently:

# Source:
# https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca1039.pdf
(2.4 GHz and 5 GHz)
# https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca1081.pdf (6 GHz)
country HK: DFS-ETSI
(2400 - 2483.5 @ 40), (36)
(5150 - 5250 @ 80), (23), AUTO-BW, NO-OUTDOOR
(5250 - 5350 @ 80), (23), DFS, AUTO-BW, NO-OUTDOOR
(5470 - 5730 @ 160), (27), DFS
(5730 - 5850 @ 80), (36)
(5945 - 6425 @ 160), (24), NO-OUTDOOR



Update :

# Source:
# https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca1039.pdf
(2.4 GHz and 5 GHz)
# https://www.ecfr.gov/current/title-47/chapter-I/subchapter-A/part-15/subpart-E
(2.4 GHz and 5 GHz)
# https://www.etsi.org/deliver/etsi_en/301800_301899/301893/02.00.07_20/en_301893v020007a.pdf
(2.4 GHz and 5 GHz)
# https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca1081.pdf (6 GHz)
# https://www.etsi.org/deliver/etsi_en/303600_303699/303687/01.00.00_20/en_303687v010000a.pdf
(6GHz)
country HK: DFS-ETSI
(2400 - 2483.5 @ 40), (36)
(5150 - 5250 @ 80), (23), AUTO-BW, NO-OUTDOOR
(5250 - 5350 @ 80), (23), DFS, AUTO-BW, NO-OUTDOOR
(5470 - 5730 @ 160), (30), DFS
(5730 - 5850 @ 80), (36)
(5945 - 6425 @ 320), (23), NO-OUTDOOR

Reason for change in 5470-5730 :
The HK department, OFCA has its own requirement, 30dbm in addition to
EITHER fulfilling FCC OR ETSI requirement. The rationale behind is
having the biggest tolerance among major world standards to be an
international city. The OFCA, 30dbm is the baseline value to be
fulfilled in the highest priority.

About FCC
27dbm (500mW) without TPC, 30dbm (1W) with TPC
# https://www.ecfr.gov/current/title-47/part-15/subpart-E#p-15.407(h)(1)

About UTSI (same as FCC)
27dbm (500mW) without TPC, 30dbm (1W) with TPC
# https://www.etsi.org/deliver/etsi_en/301800_301899/301893/02.00.07_20/en_301893v020007a.pdf
(page 17)

A TPC (30dbm), 802.11h edition should be taken instead of 27dbm as I suggest.
Or a TPC regulation flag may be a good idea to bind with 30dbm together.


Reason for change in  5945 - 6425 :
The HK department, OFCA requires to have its own EIPR limit, 24dbm in
addition to ETSI 23dbm.
Therefore, the smaller value should be taken.
(6GHz in HK requires no reference to FCC standards, unlike 5GHz situation)
WIFI 7 allows 320MHz, the previous value, 160MHz was in wifi 6E era.

# https://www.etsi.org/deliver/etsi_en/303600_303699/303687/01.00.00_20/en_303687v010000a.pdf
(page 17)


-- 
Regards,

Morgan Wong
