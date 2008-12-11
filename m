Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:55414 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760558AbYLKTtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 14:49:55 -0500
Received: by yx-out-2324.google.com with SMTP id 8so547069yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 11:49:54 -0800 (PST)
Message-ID: <b6c5339f0812111149h6f243682t9a34691f80b4cfe5@mail.gmail.com> (sfid-20081211_205006_865046_91FC1717)
Date: Thu, 11 Dec 2008 14:49:53 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Jouni Malinen" <jouni.malinen@atheros.com>
Subject: Re: [PATCH] ath9k: Do not remove header padding on RX from short frames
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	"Patrick McHardy" <kaber@trash.net>
In-Reply-To: <20081211162213.GA28193@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081211162213.GA28193@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 11, 2008 at 11:22 AM, Jouni Malinen
<jouni.malinen@atheros.com> wrote:
> The 802.11 header is only padded to 32-bit boundary when the frame has
> a non-zero length payload. In other words, control frames (e.g., ACK)
> do not have a padding and we should not try to remove it. This fixes
> monitor mode for short control frames.

Thanks Jouni, that clears up the question of the same code in ath5k
(http://marc.info/?l=linux-wireless&m=122888546315200&w=2).

-- 
Bob Copeland %% www.bobcopeland.com
