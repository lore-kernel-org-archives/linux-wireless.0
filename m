Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37B530C630;
	Tue, 26 May 2026 17:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779815717; cv=none; b=P3p2B/rUTBTEV559VmazwXVbDCZaZ03WCWxmgO5ACgegxUs2HxfQR2C47yLu1eo8IFF3giwRzhO16DFmCaG5t49552QwHdGNkwbnmad6538RJzFvSisC2v5HSeHLVexmQuiUte4o0ceGKJIp1BSA/Td3WplWg2KMyITSj5C+dMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779815717; c=relaxed/simple;
	bh=NOmBkTqbakyfOUVdORZfgwK+dXAs70959cFjhBJn8Es=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=rEnLM7B/UmoZJazmtMqpkmbf79JV+Dg81eDmnuWYxWcRWjDY71y/CoGWNvi9sSIQ/AsnfiYA2dDpfWbAJF9s25GEC0KJNhSD7s+nxzWHD+YRhgzDPj7+e7yb0yg471YBfc2317oeKm7PrHWdt1RZV4NMQbLDxNcKZ85CDH9HRZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Miztqc4y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Miztqc4y"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C47501F000E9;
	Tue, 26 May 2026 17:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779815715;
	bh=ftZ/BVwDkJqs6UrSYS/Zjek1XjF16mMX5AsHng25tho=;
	h=Date:From:To:Cc:Subject:References;
	b=Miztqc4yA2odP+0Ywcb6TJNSHpIaC1UgP4Dnq/+LkmpKFbz1JyOqzJtj9VOEcFpDc
	 dtL7Cd7FL1tB79uWD2M5WC3P7pqo2s6JU3B/G9zdBY/lLJSGIepfH7CgZ+RQ2x5FZT
	 KD5Se1dVl6mm+ZrBQNF/zU186aHgoBn6refteqmY7x1wQKbuHVfzqkzLRo8lywa98V
	 uoq5QMNbfbKaSH7IauNzEL8oKZQqRJBJHtSwKPmf/MSBWnFMEuIJJCXg13N4xjbP8C
	 VqYwd7Jx/F/tX0UGMesw4b2tTYcLe3PcbU1eMffjr3rIwXCKVEo41XdycA87IaysSe
	 UReqqA0Wzb+UA==
Date: Tue, 26 May 2026 19:15:12 +0200
Message-ID: <20260526171224.274187786@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
 Miroslav Lichvar <mlichvar@redhat.com>,
 John Stultz <jstultz@google.com>,
 Stephen Boyd <sboyd@kernel.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 thomas.weissschuh@linutronix.de,
 Arthur Kiyanovski <akiyano@amazon.com>,
 Takashi Iwai <tiwai@suse.com>,
 linux-sound@vger.kernel.org,
 Rodolfo Giometti <giometti@enneenne.com>,
 Vincent Donnefort <vdonnefort@google.com>,
 Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 kvmarm@lists.linux.dev,
 Oliver Upton <oupton@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 netdev@vger.kernel.org,
 Miri Korenblit <miriam.rachel.korenblit@intel.com>,
 Johannes Berg <johannes.berg@intel.com>,
 Jacob Keller <jacob.e.keller@intel.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Peter Hilber <peter.hilber@oss.qualcomm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 virtualization@lists.linux.dev,
 linux-wireless@vger.kernel.org
Subject: [patch 21/24] ALSA: hda/common: Use
 system_device_crosststamp::sys_systime
References: <20260526165826.392227559@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

sys_systime is an alias for sys_realtime. The latter will be removed so
switch the code over to the new naming scheme.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: linux-sound@vger.kernel.org
---
 sound/hda/common/controller.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/hda/common/controller.c
+++ b/sound/hda/common/controller.c
@@ -525,7 +525,7 @@ static int azx_get_time_info(struct snd_
 			break;
 
 		default:
-			*system_ts = ktime_to_timespec64(xtstamp.sys_realtime);
+			*system_ts = ktime_to_timespec64(xtstamp.sys_systime);
 			break;
 
 		}

