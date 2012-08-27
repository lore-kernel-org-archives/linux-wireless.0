Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46107 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2H0PYm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 11:24:42 -0400
Received: by obbuo13 with SMTP id uo13so8311711obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Aug 2012 08:24:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVMQckH9KYp=OZorb2Q__91VrC-V5MNqE+zXsCTN4B5=dg@mail.gmail.com>
References: <1346063887-29078-1-git-send-email-yeohchunyeow@gmail.com>
	<CAG6hwVMQckH9KYp=OZorb2Q__91VrC-V5MNqE+zXsCTN4B5=dg@mail.gmail.com>
Date: Mon, 27 Aug 2012 23:24:42 +0800
Message-ID: <CAEFj984VD6VmnX5nP0bCV7-pb-YPQ55eX2Gusg4G4jwRV7O9ng@mail.gmail.com> (sfid-20120827_172446_264400_303326CA)
Subject: Re: [PATCH] cfg80211: allow software encryption of aes cmac in mesh
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Thomas

> So what does this patch fix, exactly? mac80211 already advertises
> support for AES CMAC if the hardware is MFP capable.

I think that ath5k is not hardware MFP capable, but actually could do
AES CMAC in software. But key installation using AES CMAC of authsae
on the multicast management frame are failed due to the checking of
cfg80211_supported_cipher_suit which is based on
IEEE80211_HW_MFP_CAPABLE. So the only way is bypass this checking.
What do you think?

--
Chun-Yeow
