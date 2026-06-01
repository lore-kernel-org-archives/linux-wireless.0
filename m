Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6C62BFC8F
	for <linux-wireless@vger.kernel.org>; Mon,  1 Jun 2026 16:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780330690; cv=none; b=AamOe9g3PtzHCJ8pu31oU9LAQzka2F2f9nFK6pxPPBU7BbqvuZdipk13DIKT89TQlt9ldpvAZh22UxmkSPPzCjhL/bo0YJuHS9NJfMGb4bR5JC11AFhqXS/WYk/TiIlcQKxuEYchWoQyjr0WBnnQUQOxOuyD/EJ//1PAIq+buao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780330690; c=relaxed/simple;
	bh=Tc6jK/7brIIACYocCFy1E8HxOAwoBSt48T3NTbPAIX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r5BnetApc8bKqJdXOwPWl5MuPaGZjjUTIb77RasDFBtJJyL+6rRrtguqz6I1kyh8nz+DaJai9DDZYrtIaCPlJpQk04Npf89WAvHR/ZHaz2T51ONi/AHXDvdvZImak5BGRWc3MHudcSBK6Z/7FX3slcZKIyueziGmQ753xsl0nM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=fM5vKNM6; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="fM5vKNM6"
Received: (wp-smtpd smtp.wp.pl 9826 invoked from network); 1 Jun 2026 18:17:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1780330679; bh=puuoZPZvTZTsiAJsLa6nV+cakc8lR5BMkPAbKT3JeKw=;
          h=From:To:Cc:Subject;
          b=fM5vKNM607Uz6mv3DJLWXJ1Uco41yTsROx38eCZJZ6HWdGbk86bfoo6Cy+rAX90IK
           zz/RkjEF8yBQTZWXtK9uuFhIN+j+skVERAsfiRUPAFgD3W+BTxBj+ya97xFPsB6aoK
           sPQfYrWlqv4Ja4xJ2HsqXYxWx2D4Fw3FpTgHaSnoeA/SZ4dEzwdcbAmlZ4ey0JkAvr
           coJawRw5Y3KW5Ty83/EOH+UeDmoaiIYpHME0o6ck4wfCyOJ4RtJoEvlk1W6AH8+CXk
           ifiJq9rV4fK6FbI6ERJWELx7+Wj3/c5ur3qW5DWOt7m4xtody1YrmPUhDoO97/EaJN
           /PnZZPcsUjuog==
Received: from 77-236-11-238.static.play.pl (HELO localhost) (stf_xl@wp.pl@[77.236.11.238])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <clabbe.montjoie@gmail.com>; 1 Jun 2026 18:17:59 +0200
Date: Mon, 1 Jun 2026 18:17:58 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: wireless: ralink: RT2X00: regression, hostapd do not work
 anymore on 6.18.33 (work on 6.18.26)
Message-ID: <20260601161758.GA48421@wp.pl>
References: <ahxBexU0n_yb__EV@Red>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahxBexU0n_yb__EV@Red>
X-WP-MailID: 3aabe52c3b2b16e726a48465e7ec8cc1
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [UVLh]                               

Hi,

On Sun, May 31, 2026 at 04:11:07PM +0200, Corentin Labbe wrote:
> Hello
> 
> I have an hostapd setup with a 
> 01:00.0 Network controller: Ralink corp. RT2790 Wireless 802.11n 1T/2R PCIe
> 
> The setup work fine on 6.18.26-gentoo
> It breaks on 6.18.33-gentoo
> 
> I found an hint in dmesg:
> On 6.18.26-gentoo I see:
> May 31 15:48:45 trash01 kernel: ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 0003 detected
> 
> On 6.18.33-gentoo I see:
> May 31 15:22:57 trash01 kernel: ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 0006 detected
> 
> The RF chipset seems badly detected.

I do not see any rt2x00 related changes between upstream v6.18.26
and v6.18.33. Assuming gentoo does not provide own extra patches,
seems the issue be in some other subsystem, maybe PCI. 

Then the best way get solution to the problem would be to find 
offensive commit using git bisection:
https://docs.kernel.org/admin-guide/bug-bisect.html

You can also try if by a chance bug is not yet fixed in just
released v6.18.34

Regards
Stanislaw
