Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from home.einfach.org ([80.86.92.145]:44988 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab0CIAYw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 19:24:52 -0500
From: Bruno Randolf <br1@einfach.org>
To: jorge@dti2.net
Subject: Re: [PATCH v2] ath5k: fix I/Q calibration (for real)
Date: Tue, 9 Mar 2010 09:24:35 +0900
Cc: me@bobcopeland.com, linville@tuxdriver.com, 8an@praha12.net,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, benoit.papillault@free.fr
References: <20100308025841.7460.69949.stgit@void> <4B94F183.2080002@dti2.net>
In-Reply-To: <4B94F183.2080002@dti2.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003090924.35470.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 March 2010 21:45:55 Jorge Boncompte [DTI2] wrote:
> El 08/03/2010 3:59, Bruno Randolf escribió:
> > 4.) we can't use ENABLE_BITS when we want to write a number (the number
> > can contain zeros). also always write the correction values first and
> > set ENABLE bit last, like the HAL does.
> 
> 	Hi Bruno,
> 
> 	does not ath5k_hw_commit_eeprom_settings() have the same problem 
described
> above when committing the IQ values from the EEPROM? legacy-hal does
> differently too.

yes, but i have fixed that in the second patch of this series:

[PATCH 2/3] ath5k: read eeprom IQ calibration values correctly for G mode

i forgot to mention that in the changelog.

bruno
