Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584C028C037
	for <linux-wireless@vger.kernel.org>; Mon, 27 Apr 2026 10:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777287296; cv=none; b=UQ4ShZp9awj6A2x8GD7dUEDFTsH54BFsrkcy/TcnqiZmLTqIbzLTewMTQt0OdtBTHOoy1sVg+IPRDPNOXvLSQWMTAovPXs8fMG5+5i+n8xaEmlhOfzdQDPsRfTvOeQkDiGbPipZA3JzW4aUlWw17Gcql60bn8yWDh+bLuy4W190=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777287296; c=relaxed/simple;
	bh=KPMzQQc47aZMmU8J/CZeVrvZFmqfmCK77mTCTDUb94k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tszl1zQP84qTnCs74cCjZ+oxgwazPdv4I8s3urFHQI84Af+TNrT05TO/xqzm410DjBwzzwJPzdJ97OzA0r7sCqlRSCuzTeaL24lX1ju4hmSUpwwGW1Lnv0D3bioLcrX1R6u6DbGVp8xxTWahWCzbBtq3p1HQdVNNMAegHY2JWd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=r5q+N00o; arc=none smtp.client-ip=212.77.101.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="r5q+N00o"
Received: (wp-smtpd smtp.wp.pl 49093 invoked from network); 27 Apr 2026 12:54:50 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1777287290; bh=XUIpyvOm5wGOtqcinWiC1naj+4vbINgj64Z3+yq/Fzo=;
          h=From:To:Cc:Subject;
          b=r5q+N00o+LdzYho9Xo86GPOx83zNjgs6SaPu9CZjGdW3GADFDZtMnd1l6E6nYOwPL
           Vue7podesrrQnKRz27cUbUB9lTzuEnpEOnCkXITy1uScYDUKj6MnC58WpWHobsjgFy
           BbmIi0Fbc3TB7wzdeUCSt06Ds30MkGwfku6WiV+uW4hsLxL+yJkJzRhsUcOR7dNEno
           G2Wl1/StUTwLBevHNkL6yD5TmTjyNSXKGdo4z4S4GsxfP/u9LojW0pLeENYTMoiiJr
           PLNG7wXzHvAI3LJFh7LzYS9umv23/CkyhBv/OgoJJL4FXIyM3UW7JDMYX6maTkypL2
           Too8/TdgqtJAQ==
Received: from 77-236-6-40.static.play.pl (HELO localhost) (stf_xl@wp.pl@[77.236.6.40])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <johannes@sipsolutions.net>; 27 Apr 2026 12:54:50 +0200
Date: Mon, 27 Apr 2026 12:54:45 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH wireless-next] wifi: rt2x00: check for of_get_mac_address
 error
Message-ID: <20260427105445.GA2620@wp.pl>
References: <20260427051652.954059-1-rosenp@gmail.com>
 <20260427073206.GA2096@wp.pl>
 <c2263e4917557cb1e07a56c3bfb9a0507bf81f00.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2263e4917557cb1e07a56c3bfb9a0507bf81f00.camel@sipsolutions.net>
X-WP-MailID: e97d4ae61c97f37b37c95343ab14ed02
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [UQKR]                               

On Mon, Apr 27, 2026 at 12:45:14PM +0200, Johannes Berg wrote:
> On Mon, 2026-04-27 at 09:32 +0200, Stanislaw Gruszka wrote:
> > On Sun, Apr 26, 2026 at 10:16:52PM -0700, Rosen Penev wrote:
> > > is_valid_ether_addr is already a check of of_get_mac_address, in which
> > > case it returns an error if false. Just set a random MAC on all errors
> > > except for EPROBE_DEFER.
> > > 
> > > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
> 
> Are you sure? I just randomly checked one caller to see what the
> *eeprom_mac_addr would contain, and I see
> 
>         mac = rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
>         rt2x00lib_set_mac_address(rt2x00dev, mac);
> 
> so that case assumes it can get it from EEPROM and override with OF, but
> if OF fails then it would still use the EEPROM address as long as it's
> valid ...

You have right, please drop the patch. 

BTW, the code should be changed to move getting the address from OF
out of _set routine. 

Regards
Stanislaw
