Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52226 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab2HXGz1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 02:55:27 -0400
Message-ID: <1345791322.4503.0.camel@jlt3.sipsolutions.net> (sfid-20120824_085533_586718_66888795)
Subject: Re: [PATCH] ath5k: set hw mfp capable flag for secured mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@lists.ath5k.org
Date: Fri, 24 Aug 2012 08:55:22 +0200
In-Reply-To: <1345778993-23033-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120824_053128_684894_141999F9)
References: <1345778993-23033-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120824_053128_684894_141999F9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-08-24 at 11:29 +0800, Chun-Yeow Yeoh wrote:
> The IEEE80211_HW_MFP_CAPABLE is required to ensure the
> successful key installation of CIPHER_AES_CMAC (currently
> done in software) for secured mesh.

You shouldn't blindly set the flag though because it "is required". You
really need to test that management frames aren't decrypted by the
hardware erroneously.

johannes

