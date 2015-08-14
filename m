Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37821 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbbHNHES (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 03:04:18 -0400
Received: by wibhh20 with SMTP id hh20so10460141wib.0
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2015 00:04:16 -0700 (PDT)
Date: Fri, 14 Aug 2015 09:04:08 +0200
From: Adrien Schildknecht <adrien+dev@schischi.me>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "Berg, Johannes" <johannes.berg@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: out-of-bounds access in
 iwl_init_sband_channels
Message-ID: <20150814090408.1521e8fe.adrien+dev@schischi.me> (sfid-20150814_090422_315956_7EAD22B7)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7EA2CE@hasmsx107.ger.corp.intel.com>
References: <1439512532-7901-1-git-send-email-adrien+dev@schischi.me>
	<0BA3FCBA62E2DC44AF3030971E174FB32E7EA2CE@hasmsx107.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> On 08/14/2015 03:36 AM, Adrien Schildknecht wrote:
> > Both loops of this function compare data from the 'chan' array and
> > then check if the index is valid.
> > 
> > The 2 conditions should be inverted to avoid an out-of-bounds
> > access.
> > 
> 
> Was that found by a static analyzer or any other automated tool, or
> was that the result of your very careful review?

The error has been reported by KASan:
==================================================================
BUG: KASan: out of bounds access in iwl_init_sband_channels+0x207/0x260 [iwlwifi] at addr ffff8800c2d0aac8
Read of size 4 by task modprobe/329
==================================================================

-- 
Adrien Schildknecht
