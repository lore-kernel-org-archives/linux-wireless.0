Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ppsw-9.csi.cam.ac.uk ([131.111.8.139]:51931 "EHLO
	ppsw-9.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbXLWEIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 23:08:40 -0500
Received: from ssnt2.quns.cam.ac.uk ([131.111.255.37]:40185 helo=neotoaster.lan)
	by ppsw-9.csi.cam.ac.uk (smtp.hermes.cam.ac.uk [131.111.8.159]:25)
	with esmtpsa (PLAIN:ssnt2) (TLSv1:DHE-RSA-AES256-SHA:256)
	id 1J6I8k-0004Ma-Tc (Exim 4.67) for linux-wireless@vger.kernel.org
	(return-path <ssnt2@hermes.cam.ac.uk>); Sun, 23 Dec 2007 04:08:38 +0000
From: Shawn Tan <ssnt2@eng.cam.ac.uk>
Reply-To: ssnt2@eng.cam.ac.uk
To: linux-wireless@vger.kernel.org
Subject: Re: B43 not working
Date: Sun, 23 Dec 2007 04:08:37 +0000
References: <200712230117.35920.ssnt2@eng.cam.ac.uk> <20071223041739.1f9e82cb@morte>
In-Reply-To: <20071223041739.1f9e82cb@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712230408.37562.ssnt2@eng.cam.ac.uk> (sfid-20071223_040852_348588_9ED91BD1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 23 December 2007 03:17:39 Stefano Brivio wrote:
> You can just grab the tree/branch John suggested, or, in case you don't
> want to mess with git and a complete kernel rebuild, please see:
> http://linuxwireless.org/en/users/Download

Yup, that's what I did. I downloaded the compat-wireless package and compiled 
it. However, it seems like there's a compatibility problem with the package 
modules and the default Ubuntu ones.

When I try to load rc80211_simple, it loads the ubuntu one. The compat package 
doesn't build a rc80211_simple. So, if I load the ubuntu rate controller, it 
loads the ubuntu mac80211, which has similar symbol problems with the b43 
module.

Oh yea, I'm using the ubuntu 2.6.22 kernel. I guess I should just be patient, 
wait a few more weeks for 2.6.24 and try that instead.

Errors when loading the ubuntu rc80211_simple:

[ 2245.492000] rc80211_simple: disagrees about version of symbol sta_info_put
[ 2245.492000] rc80211_simple: Unknown symbol sta_info_put
[ 2245.492000] rc80211_simple: disagrees about version of symbol 
ieee80211_rate_control_unregister
[ 2245.492000] rc80211_simple: Unknown symbol 
ieee80211_rate_control_unregister
[ 2245.492000] rc80211_simple: disagrees about version of symbol 
ieee80211_rate_control_register
[ 2245.492000] rc80211_simple: Unknown symbol ieee80211_rate_control_register
[ 2245.492000] rc80211_simple: disagrees about version of symbol sta_info_get
[ 2245.492000] rc80211_simple: Unknown symbol sta_info_get

Cheers.

-- 
with metta,
Shawn Tan

Centre for Advanced Photonics and Electronics
Department of Engineering, University of Cambridge
9 JJ Thomson Avenue, Cambridge CB3 0FA, UK.
