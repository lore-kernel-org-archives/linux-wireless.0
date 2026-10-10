Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABFB3C456B
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 13:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639612; cv=pass; b=H5H+biIUu5sOmSzXcPkDHxOJXNnIDNc+VPDs9IaoF1BxT8HR55rGEfUytFlnNb+w+yCev+EJ5CPuXDp41LdCjRcc3fioEjSoPIg4OjRd+VEKgNs+4dDTFrpJPfoazvf1BQrNn0LwbAXOrlWehfgx9cMD8SNM4QoZYEWr9qH4qwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639612; c=relaxed/simple;
	bh=iYqhoVZ+Jyml4P0MGYzZBl9up/LYhbapQ8gAv8jGngA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uv1Kqzxuoa4ZoQo5/PP9YzpmpQNFMTtzLOWFUUdeXn2/Vwvl/9N3V3oV5DtlVgJMDRtRVCpvII3T6Jk8032DvfQI4DDjlfS/YR9NMYkIxN/JYsG8ueecQXAib/jr8x0bt55XX7AhqQYKT6Xkdww0tfM8JwPLENBXK3I1NptUrz0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZXAZ9GWq; arc=pass smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZXAZ9GWq"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3a75f960be3so5928211fa.2
        for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 06:40:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791639609; cv=none;
        d=google.com; s=arc-20260327;
        b=axv2qfty/kfpQrh8TZjuI3noOKpFU0Pj9pW2NFQl/c5H7u+m43xgEHQTytd3AmDUny
         C7YaKEU875EmgcmdVC00rHv4vs7Xg5iKNjv26i/aOxAjPi/XfI74FSJACUjQ1XzLHbaV
         w/bu3jPdlIP+rZ2RPIfXDF+ivbKq7oJlg4zAhVFAlXHcrH1Tkoj+ZB1LpjLISkvwbkac
         YO0ap8yVte9i466IlSxIDBVYm3Yq21OYJKDE1BbU3v3V6Xd0a8Q1h+qL3qdRnh70BNuy
         dNF92/uhAzzpAALRL1nMnwLqRu5nmX23P4kk/UxBoLq5KRSPT1nUL80VElu+nnzPoDVQ
         E1uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1OMPvqt3i2+F+trWLfv914nMC+RGH+n0BOpujrLH77w=;
        fh=rddV5u2g36U7qfJ5usM6xYDaD5WmttoU20thQylLahE=;
        b=EKP6udaEjQqHZhNSUUAZITh17sgH2+zHbEQtYHgsCjzes6ySkkcTLfnuVmaX9cVuse
         bk8w98u6NVjomM7EXKI3le3XbYiJkeKiqXU5wiPtqUJDMuaMoNUjKFSqT5BxONu3m4qy
         XiBCkeoV+jRYYnU+Ku2f/Hh6ZRr3rdhMUBkvqjfIBgNyuQCDWX8b2T+tmi8i5W0PRxsd
         IY57tUXRCrGMCxAGG41BFIHOeApG+/y2bVYlH3aCcGVZ2ev9ROKUfLUyNeFSA2VGJDmS
         rE4iPGbmwFPvNW5U8eSLoPGGKqKYGVX8vo/KJlgZdJm7EP+G9hbXnWqNvLC5uameJfn2
         o55A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791639609; x=1792244409; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1OMPvqt3i2+F+trWLfv914nMC+RGH+n0BOpujrLH77w=;
        b=ZXAZ9GWq2w2N/D2wWSTnlOkfEAe51ltRLDrYbuiULJDm7BKDbfNcqJWB0jDk7LsJjM
         zpSXQMq21iq+Uq4i8loxLMWjHSNKMJN5vv3+jzIc+STsBnF0cIELEho0GZTiYEOR4jsi
         3J9Rs9gsSPM63oCfE135zN/SgdVq9hbvy2yta4oTJ1JHo1HNhDajWflXmGiG8XLuDl69
         HGSLHWTR9gUOvDtkqc6O58y8bw44wmUW5ejuuNyf0AV4OrrVqWK48M92yJDeGDYzsTGe
         UECbrTh73toJRj+3j/J+SuN3rtW6enoSZ7iIctMYVc6JKYEbsu6meBwLNhxeWVVF97ec
         brkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791639609; x=1792244409;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1OMPvqt3i2+F+trWLfv914nMC+RGH+n0BOpujrLH77w=;
        b=d9mRIt5bs+4nk1YGmHwz4iPAlwfSu7C3zCVyMtOrata3ULGWg/tPBwe8Qj9pm4gJ5I
         ovKqofjdtYqOcyiKG+a+ZAoKwdkTj33l712kTkRk16Hu0PESU4ESxueZiGa/92N5Hwc5
         ZkKmXp2oaZM28VsqTebcwyHldIFmCJOXccxXiAD/gcKnx5B6AVcMSvi7N4s6ZgmSMsTD
         Vwg8JeV11FxBRK2Q3rmH88B3047tsGHAHo1dNy3wAWSe2dplPSK+UK+csrCEa/P/8yQz
         Jm4Tj40UIFLDxh2QcvkxM2NHZwQR9anMNrYLBvUayrQ4xSymM1JMsUUFuvqzByiTDqqW
         f/Lg==
X-Forwarded-Encrypted: i=1; AKwUvBwUCehj6H+JlMBicVSIiSJFcsFN9OxXh5Y58lsqH9LJG9RqHHQQUaPUu/vYrifaDT5gv62xb3ThOCE2nOtUaQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIYgY3ou3DJHSLpxVqUVIwAlwKAPdX6moO5SEZgGCTWEdN0niEH
	gkJfcRTIplYqZJND/3ieDWvnmkGOvCkYo3PT9LAEu/H/xvMkPl696xVRm/tVGKQFwXa8oaeOkhu
	dfPVb4wJgT94cdrgL21ssc6c2VvrjGHA=
X-Gm-Gg: AYBFou0DVN6HMRNMcyyIr7AB2gChYgFPrXq7tpgleA5al6oz10DiJJ9G7FM7GapYLpR
	MNVit6/CmheTG5VbEovneUG5Yvt5KF4MtOlV0wv1a6zkumR/jDEGISrYhEEqYW4FzsMSRzfTZNR
	0aVUZkaoDjm+qWanKi2ZBZj5OZ0BjvYJ8t3s2aBqrh5jPv1LWLVXj46bKrFdEUZl30dgBdKtOVq
	azlmCHvpvkjr6ogl66BB8RmjNdKurDlJn5mgxFaRH1CZYbrrJMRqaOHT0pqaqQ+Rd7mPMnlDwlP
	yOVAu3gC6IMcqEtg+fZ2n/qgPDBL+Q/te57gUrAeT+pZPOpaK9ej61nk3l0UTX/3/3JYWo6nxf1
	+iXcO1vgMMzYCS3nI3oEpJKRNy5H0XtPR9hGkVsAAF58E
X-Received: by 2002:a05:651c:54d:b0:3a9:7f37:9bbc with SMTP id
 38308e7fff4ca-3a9c535761amr10525921fa.11.1791639608635; Sat, 10 Oct 2026
 06:40:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261007115821.11332-5-sigefriedhyy@gmail.com> <179154713266.434549.3119718667275543634@kernel.org>
In-Reply-To: <179154713266.434549.3119718667275543634@kernel.org>
From: Yuyang Huang <sigefriedhyy@gmail.com>
Date: Sat, 10 Oct 2026 22:39:57 +0900
X-Gm-Features: AclHuK-8lTLLnkYqyGO4ub-KfSnA41bLKl_MgKWzh-nerGwP6xbhIB0UlOeiU2Q
Message-ID: <CA+7S2vJEYr7sbRqf=QdURN+gLp=5aaRGXG3iprA5Rz4-sEqj3w@mail.gmail.com>
Subject: Re: [PATCH net-next v10 4/6] net: add AF_PACKET multicast dumps
To: netdev-bot+sashiko@kernel.org
Cc: ajay.kathat@microchip.com, aleksandr.loktionov@intel.com, 
	andrew+netdev@lunn.ch, claudiu.beznea@tuxon.dev, davem@davemloft.net, 
	dsahern@kernel.org, donald.hunter@gmail.com, edumazet@google.com, 
	idosch@nvidia.com, jacob.e.keller@intel.com, kuba@kernel.org, 
	johannes@sipsolutions.net, kees@kernel.org, kory.maincent@bootlin.com, 
	kuniyu@google.com, nicolas.dichtel@6wind.com, nickgarlis@gmail.com, 
	pabeni@redhat.com, sd@queasysnail.net, shuah@kernel.org, horms@kernel.org, 
	sdf.kernel@gmail.com, vadim.fedorenko@linux.dev, willemb@google.com, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> - [Medium] dev_mc_dump() (net/core/dev_addr_lists.c) calls
>   nl_dump_check_consistent(cb, nlmsg_hdr(skb)) once at the end of every=
=E2=80=A6

> - [Medium] dev_mc_dump() reads the generation (cb->seq =3D
>   dev_mc_base_seq()) only after the walk, once dev_mc_dump_dev() has=E2=
=80=A6

Both are real and are the same problem as reported on patch 3, will fix in =
v11.

> - [Low] At this commit, Documentation/netlink/specs/rt-addr.yaml is not
>   updated for the new AF_PACKET RTM_GETMULTICAST dump.

This is done in the same patch series.
