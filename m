Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EB0194AD2
	for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2024 12:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718627862; cv=none; b=XsaCymoifS1QlYDAgoo8e4xu4jzNb7aCnP0Asbb04Y73W9z8XIg9q7SLoKwvby1mpDbp2GcZkHD6zRHQfsGO508cKe5S1S0uvPRzMHSdbPN1ZZRzGoAKgpGLIKxrt9Jq4Pxu7UMHuF5U+4dbwUPwBnVRm0B/j7agoF/uW70etVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718627862; c=relaxed/simple;
	bh=FHG/Z5igpntqMvstAA70RVTUqJgDraE35vkl5rN9o7s=;
	h=From:To:Subject:Date:Message-ID:References:Content-Type:
	 MIME-Version; b=GiSOYxRB7QIVg9JBqoyfonQFa005anBjMCvxgI/J1V9OlbWML7oFPuNQCy2mInJSUJZhoa4w/gLnhWjYNW+UMwGqt9YHkwjjWmohwn/pFv5uHArkgQRE3z/dVy9XMUbFSaENvQtej/g63CV/Bp+Ti7JIn79HQGDvS6MGLWwxhRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
X-SpamFilter-By: ArmorX SpamTrap 5.78 with qID 45HCbU5z93198046, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
	by rtits2.realtek.com.tw (8.15.2/2.95/5.92) with ESMTPS id 45HCbU5z93198046
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 20:37:30 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 17 Jun 2024 20:37:30 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 17 Jun 2024 20:37:30 +0800
Received: from RTEXMBS03.realtek.com.tw ([fe80::b9ff:7c04:a2d:c266]) by
 RTEXMBS03.realtek.com.tw ([fe80::b9ff:7c04:a2d:c266%2]) with mapi id
 15.01.2507.035; Mon, 17 Jun 2024 20:37:30 +0800
From: Zong-Zhe Yang <kevin_yang@realtek.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wifi: mac80211: fix NULL dereference at band check in starting tx ba session
Thread-Topic: [PATCH] wifi: mac80211: fix NULL dereference at band check in
 starting tx ba session
Thread-Index: AQHarOpgkYVLW/TkN0STRQVqWrvRWLGttqwAgAIG0bCADGJAgIAK0wNggAUVc4A=
Date: Mon, 17 Jun 2024 12:37:30 +0000
Message-ID: <1bfef659b21d46ef8cd536394fcb2eb8@realtek.com>
References: <20240523082200.15544-1-kevin_yang@realtek.com>
	 <173a8af7e9b544c496f2aee2bb47fca99279873c.camel@sipsolutions.net>
	 <639f8c2b59eb42beb56b28e53307886a@realtek.com>
 <c3ce5ca1cb434c2ff4b9ee3a1be9d81bf5ae01b2.camel@sipsolutions.net> 
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Zong-Zhe Yang <kevin_yang@realtek.com> wrote:
>=20
> [...]
>=20
> Then I am thinking to just check ht_supported/vht_supported/has_he/has_eh=
t on sta deflink,
> whether non-MLD connection or MLD connection.
> Any further suggestions?

I sent v2 in [1].
If there are further suggestions, perhaps we can discuss them there.

[1]: https://patchwork.kernel.org/project/linux-wireless/patch/202406171152=
17.22344-1-kevin_yang@realtek.com/
