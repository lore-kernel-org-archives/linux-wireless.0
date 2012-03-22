Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm9.bullet.mail.ukl.yahoo.com ([217.146.182.250]:22502 "HELO
	nm9.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755538Ab2CVKjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2012 06:39:52 -0400
From: Marek Lindner <lindner_marek@yahoo.de>
To: "Chun-Yeow Yeoh" <yeohchunyeow@gmail.com>
Subject: Re: [PATCH v2] mac80211: fix the RANN propagation issues
Date: Thu, 22 Mar 2012 11:33:51 +0100
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	javier@cozybit.com, thomas@cozybit.com, linville@tuxdriver.com,
	devel@lists.open80211s.org
References: <1332420968-16300-1-git-send-email-yeohchunyeow@gmail.com>
In-Reply-To: <1332420968-16300-1-git-send-email-yeohchunyeow@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201203221133.51928.lindner_marek@yahoo.de> (sfid-20120322_113956_200617_B74A1C54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I am not familiar with the 802.11s code and could be totally wrong here but ..


On Thursday, March 22, 2012 13:56:08 Chun-Yeow Yeoh wrote:
> +       if ((mpath->sn < orig_sn || (mpath->sn == orig_sn &&

.. this sequence number handling looks broken to me. What happens when the 
sequence number wraps around ? One could be smaller than the other and still 
be newer.
I know this isn't really what your patch changes.


>  #define SN_GT(x, y) ((long) (y) - (long) (x) < 0)
>  #define SN_LT(x, y) ((long) (x) - (long) (y) < 0)

Your macros tried to address the problem but casting your sequence number to 
long also breaks the wrap around.

Regards,
Marek
