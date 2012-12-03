Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:45084 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab2LCO4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 09:56:24 -0500
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: help: 802.11s bad performance with 802.11n enabled
Date: Mon, 3 Dec 2012 14:56:20 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1259A@RockMX01.rock.corp> (sfid-20121203_155653_819619_87627223)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp>
 <alpine.DEB.2.02.1212031842350.27546@icf.org.ru>
In-Reply-To: <alpine.DEB.2.02.1212031842350.27546@icf.org.ru>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CL>For experiment, I changed ath9k driver to disable 802.11n packet aggregation. The network becomes much better.
CL>It's as stable as running 802.11a only mode.
CL>So it seems that the aggregation plays a big role in in-stability of 802.11s network with 802.11n.
CL>Any one has any idea why?

Can you post a patch? i want test this too.

The change is easy
In ath9k/init.c
Function ath9k_set_hw_capab()
Replace below
    if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
         hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
with
	hw->flags &= ~IEEE80211_HW_AMPDU_AGGREGATION; 

