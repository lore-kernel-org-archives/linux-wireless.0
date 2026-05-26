Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3D8413D63;
	Tue, 26 May 2026 17:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779815726; cv=none; b=hAcF2MU8+ygupJD61omFQQf9W2G4t6oObCnl6pZGgKuQ8da3latCxWZzuICbY3TC0OeHxEa+tqxXVP+CiF1/uuqf8OnTJEgE1NzGenhUTeE7m89JoMC9qnz7Lv5Wds5N6qwFm1FRaemhdvrRpT0ZGWIBh5gHh0FKKLtNApNBqr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779815726; c=relaxed/simple;
	bh=UPQTtjMr5+Q62rEYqCbl500+U2deKAK7t7gFD28njww=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=Dc7SmDqLC18mBRy0l/ct4fEktl+DQbtDKNj5wqSMSYickc6HTbtkak/rl5EmoF27vBQ/Jotn2/ydm2Ip2ttacuKEZb81TIVORtjaE/vfI33/FRmlkk8UrJZcdLkAbWQYnGijIFEG2ilOZ7m9cYeKFvC9VW2OhR9zMNB6I/WbIUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hz5rNADp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hz5rNADp"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9E10A1F000E9;
	Tue, 26 May 2026 17:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779815725;
	bh=kHti9+sqVBZGq/j203ISTyL+B5Np9OokbIRFwk8d52M=;
	h=Date:From:To:Cc:Subject:References;
	b=hz5rNADprN6ALUeIESOs1EAHI+3FrqImMNfrKx8bHnTUUhymIz6kZ19jV9U59OEKJ
	 +oQD6+HT2X3ZFUTkTaGu8AhNw2XmcPBg0Soma/+16SPZb2sNVLr2z3EFSZif/Ph24c
	 eocOJhkBMV6pZ/Y3pRsmMYgO8Hk2+qiuC6j445ZmpdGiytf/kblpU1IzFCNjdyZF39
	 ZMyIdYvz4t+473edPLKykgFkAUlE/CLzT/fbPmf56abgPb1I+5x9lhJk4SWBgTVGVO
	 LMXqW91ZCsRmm99cZPhes8CX4bm4dBXg/NzSUpCVRTui+5VNo9rYI/L5tCxaWg0cFo
	 v8VlRWgnTi4AQ==
Date: Tue, 26 May 2026 19:15:22 +0200
Message-ID: <20260526171224.423155175@kernel.org>
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
 Rodolfo Giometti <giometti@enneenne.com>,
 Vincent Donnefort <vdonnefort@google.com>,
 Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 kvmarm@lists.linux.dev,
 Oliver Upton <oupton@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 netdev@vger.kernel.org,
 Takashi Iwai <tiwai@suse.com>,
 Miri Korenblit <miriam.rachel.korenblit@intel.com>,
 Johannes Berg <johannes.berg@intel.com>,
 Jacob Keller <jacob.e.keller@intel.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Peter Hilber <peter.hilber@oss.qualcomm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 virtualization@lists.linux.dev,
 linux-wireless@vger.kernel.org,
 linux-sound@vger.kernel.org
Subject: [patch 23/24] timekeeping: Add support for AUX clock cross
 timestamping
References: <20260526165826.392227559@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Now that all prerequisites are in place add the final support for AUX
clocks in get_device_system_crosststamp(), which enables the PTP layer to
support hardware cross timestamps with a new IOTCL.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
---
 kernel/time/timekeeping.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1518,6 +1518,12 @@ int get_device_system_crosststamp(int (*
 		tkd = &tk_core;
 		offs = &tk_core.timekeeper.offs_real;
 		break;
+	case CLOCK_AUX ... CLOCK_AUX_LAST:
+		tkd = aux_get_tk_data(xtstamp->clock_id);
+		if (!tkd)
+			return false;
+		offs = &tkd->timekeeper.offs_aux;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		return false;

