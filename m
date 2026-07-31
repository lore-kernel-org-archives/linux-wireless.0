Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE203546FC
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 06:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785479273; cv=none; b=Yt4qjiq2NzwWvu2rgE2/B4Co/RV3ZGnJwrcnaBRlzbU/VRbDKnz5h+uGOWUPSQreJSYcl/QKqlsDCKU7nUpZ4xpXVaitVzWiHl59g8HyRj+piRvstjbVfHeluvXyDadSwA9sG8FCEnII53DAFOSkMvmvOLzlQNqvC1+zyPsUGH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785479273; c=relaxed/simple;
	bh=/RIXDyJYPwQG6UAkL4Y+7YK/klbJsFGDw9aOVKqOiYo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=smmMlfGDor3AQtWaDxKHs1UaLrYf1oHqawx5aWYtkJ/8ddODqiGEzPW2BXeaAdE022om/NoiF3Xig9Na9gYpU//56j/6fkZBfHjoCZJN7vkV5nsZcSgqQQJdouHmOiWH491MZq4nFCbOkbG6PLS+XFkgVm7NtU3oYiwptVuPfZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=GWDeIag+; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="GWDeIag+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=/RIXDyJYPwQG6UAkL4Y+7YK/klbJsFGDw9aOVKqOiYo=;
	t=1785479270; x=1786688870; b=GWDeIag++z++SlFuBUxQPzgisvegMeapRJaxQiLUefo91Zc
	HUSaA4GViAGBHQq6CuZIKCCNBDga/gsVu6aAK7pKVgDkdVj/4d3WA45XYz9qxEBelMV9CzcWLGilq
	qXgZ43t0DVh87ksxumw3oKIKjHUVfsh5BPrrMt9eG1W8jd4/NOAUt5FrSG/kupmxbhbW4n2kz+YGI
	Wuq4SZLV8x0StkPymbNAZtkaL8q+6dnq0Qm4bA2tBjnMVJA3IAq4Ug6d8/dpIedmNhvOZAsN6UwP5
	iThzScqm3MbxYDWpGj+nWWpAyHA+BL37otLzvYC4VdiLj+F46IfT8e8gosGoSFIA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wpgif-0000000CruU-2Mz8;
	Fri, 31 Jul 2026 08:27:45 +0200
Message-ID: <a40d4be897d71c7f8912216d56b47b08ab311283.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2] wifi: cfg80211: fix regulatory.db
 async firmware request blocking __usermodehelper_disable()
From: Johannes Berg <johannes@sipsolutions.net>
To: Kavita Kavita <kavita.kavita@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 31 Jul 2026 08:27:44 +0200
In-Reply-To: <4d9252fc-fe64-4b34-988f-5280f41dce10@oss.qualcomm.com>
References: <20260629063159.3288957-1-kavita.kavita@oss.qualcomm.com>
	 <8857cc85-ab3d-44de-8ddc-cb9a4c22709b@oss.qualcomm.com>
	 <4ea5025bc19f0ec89a42427aadb45e943884400e.camel@sipsolutions.net>
	 <4d9252fc-fe64-4b34-988f-5280f41dce10@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2026-07-31 at 11:53 +0530, Kavita Kavita wrote:
>=20
> On 7/22/2026 3:35 AM, Johannes Berg wrote:
> > On Mon, 2026-07-20 at 10:26 +0530, Kavita Kavita wrote:
> > > Gentle Reminder!!
> >=20
> > How many exclamation marks make it non-gentle ;-)
> >=20
> > I really cannot convince myself that this patch makes sense any sense a=
t
> > all. If there's a problem between request_firmware() and
> > __usermodehelper_disable(), why would we fix it in *wireless*??
>=20
>=20
>=20
> Both request_firmware() and __usermodehelper_disable() are behaving corre=
ctly.
>=20

You skipped the question.

johannes
