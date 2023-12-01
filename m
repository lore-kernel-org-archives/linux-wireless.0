Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="xEW3Th9n"
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B412196;
	Fri,  1 Dec 2023 02:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=9PD+eSgbXXCIBgWYOOHB5YNDolmENUoJUpsocWsMFtA=;
	t=1701427417; x=1702637017; b=xEW3Th9nooAsM0W1CcZIg0b12j01TOZKH80QMYMyyOfIhPw
	19d6g24BZEOUjMgkP4ALuR5DI5iEfELiWaiEqde449TT+NqU0+0eN46gRkPB8PcwF/JS1ld3FlIgr
	SQ/UJv5g0b+DLGr2cDra87iTUWDPbn4cmjahruIKArz4nVh5DXXI2+0lYxmOq2UqyjM23/u/BOyiu
	TGqFDdCJxbSiq3x9BP0WiE+U84qmaEeDv5Jw18gWcha1vGRZw/jRlgc/Hot442xr7mRdFl6kU2hQU
	dn1WEyEROVjMOMxt3ttl8Mk3Jb69fOAikeR9OHujb7QXfPSpZ2QxiX5syJxlPBlQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.97)
	(envelope-from <johannes@sipsolutions.net>)
	id 1r90ze-0000000BBV7-3rZd;
	Fri, 01 Dec 2023 11:43:35 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: [PATCH wireless-next 0/3] netlink carrier race workaround
Date: Fri,  1 Dec 2023 11:41:14 +0100
Message-ID: <20231201104329.25898-5-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <346b21d87c69f817ea3c37caceb34f1f56255884.camel@sipsolutions.net>
References: <346b21d87c69f817ea3c37caceb34f1f56255884.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi again,

So I had put this aside for a while, but really got annoyed by all
the test failures now ... thinking about this again I basically now
arrived at a variant of solution #3 previously outlined, and I've
kind of convinced myself that userspace should always get an event
with a new carrier_up_count as it does today.

So I've implemented a new nl80211 attribute carrying the current
carrier_up_count at the time of the wireless event, so that we can
(in userspace) wait for the corresponding rtnetlink event if we
haven't seen it yet. Patches for wpa_supplicant to follow.

johannes

