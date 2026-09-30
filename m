Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD996364EA4;
	Wed, 30 Sep 2026 11:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790768430; cv=none; b=dMuS6C22u5MZzPYw39S08F3cDNQ9XpK/Gr8m9GxY0H3bAiCbNOy9yjsl/jWtgwTD7J8mKt3Itbmb15qa1fIPBxXGi0yrHPB9RnuZsbzUYtUbNKmJlJO05RAnUDSJ4UCpNaQKsEwJjOhLL8sr0oN5U7sTXwRSwFj7/OGsDhDN1LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790768430; c=relaxed/simple;
	bh=yAOnnwevtoD+Wz31eFyGSfUtSJZQIvw/mltJV+SrsEo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aKPie6G0J9xFU9LilahiAQSifx8sNEhkGzlpl1bSdtkTJrhdiFaiNSHmHGv1b0L8D01RzG55emYw5sPPfm6+RxD8sHXzV84G3gxl3kVDONGP+CkE9NoE5GBXQQFRr7LBEzgSIlsDcKUMg1dxxS/2FLdx53bGDFbV4zf4rPvIMSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=oJbfxDDi; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="oJbfxDDi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=yAOnnwevtoD+Wz31eFyGSfUtSJZQIvw/mltJV+SrsEo=;
	t=1790768428; x=1791978028; b=oJbfxDDiv2l0HEguvHfEOxwJyVpXd38cLNtxcWGLH5Ut56+
	kktP3KOtRaE4cDUXp2+bC8h4a/9lOY9ZlswGu7JfO0fH87pscXqX+cBZ0XzdTrAu5ZKKAIFnWG2lt
	bhdkF3fHDrF1dPhohN1T1aV+SZTx4xpXM3YDGOmD+tbWQ4WMB1UEJfocnHLzfEn1KaYkmqUEGXYQb
	dV1ew4FLNekdpJrlJ/pPPEq+qpUsrdYY7Cp8Bo8SHXsKXe7wVy5sT96DgPT9FmtCQqeeIYUJ1ZJAY
	tiaWnjy3RWqCfoNrJOT7gnmXw2ffs3CzmB4ouottmPj5r0jxc0xJVKIMLXvfo41Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xBsff-0000000GMHy-3MVx;
	Wed, 30 Sep 2026 13:40:24 +0200
Message-ID: <a612cb0f1cfc09b7ec7f494f22f8cc8d3ba61f10.camel@sipsolutions.net>
Subject: Re: [PATCH v1 1/1] rfkill: add rfkill_hard_blocked() helper
From: Johannes Berg <johannes@sipsolutions.net>
To: Sai Teja Aluvala <aluvala.sai.teja@intel.com>, 
	linux-wireless@vger.kernel.org
Cc: kiran.k@intel.com, chethan.tumkur.narayan@intel.com, Luiz Augusto von
 Dentz	 <luiz.dentz@gmail.com>, linux-bluetooth@vger.kernel.org
Date: Wed, 30 Sep 2026 13:40:23 +0200
In-Reply-To: <3305da8e844c9d0a5de5848b596d16de8d462048.1790752797.git.aluvala.sai.teja@intel.com>
References: <cover.1790752797.git.aluvala.sai.teja@intel.com>
	 <3305da8e844c9d0a5de5848b596d16de8d462048.1790752797.git.aluvala.sai.teja@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2026-09-30 at 13:12 +0530, Sai Teja Aluvala wrote:
> rfkill_blocked() reports the effective block state, i.e. set when the
> device is either hardware or software blocked, and rfkill_soft_blocked()
> reports only the software state. There is no equivalent accessor for
> the hardware-only state, and struct rfkill is opaque to drivers, so a
> caller that needs to distinguish a hardware block from a software block
> cannot do so.
>=20
> Add rfkill_hard_blocked(), which reads RFKILL_BLOCK_HW under
> rfkill->lock in the same way as rfkill_soft_blocked(), together with a
> stub returning false when CONFIG_RFKILL is disabled.
>=20
> The first user is the Bluetooth HCI debugfs force_hw_rfkill test hook,
> which must report and compare against the hardware state only.

Probably should CC Bluetooth list (done now) for a change that's prep
for BT infrastructure.

The user is:

https://lore.kernel.org/linux-bluetooth/af7525184b7c910d8f5bc313805ac312937=
11c19.1790752799.git.aluvala.sai.teja@intel.com/

which does two things with it:

 1) refuse debugfs write when it's already hw-blocked by some real hw

 2) show the rfkill's hw-blocked status in debugfs read

The tool that's intended to use the debugfs file is this:

https://lore.kernel.org/linux-bluetooth/66971d6f85d714f2728b29fada7136d5a2f=
bb3c2.1790752800.git.aluvala.sai.teja@intel.com/

It implicitly uses the write part by failing if the write fails, and
explicitly uses the read part by checking that it applied.

The write part could be easily checked in the tool from userspace via
rfkill sysfs (it already accesses that), and the validation against
sysfs already happens on the read as well there, so IMHO neither is
necessary - the tool could check sysfs before starting the test and
abort if it's already hw blocked before, and the debugfs read isn't
necessary at all since it reflects the exact same value as the rfkill
sysfs read, so validating both is useless.


However, if BT folks disagree with my assessment then feel free to just
merge this patch along with the user.

johannes
