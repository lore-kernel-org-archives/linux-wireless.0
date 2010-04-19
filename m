Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:11290 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab0DSQeQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 12:34:16 -0400
Subject: Re: rc80211_minstrel.c:70 WARNING with 2.6.34-rc4
From: Pavel Roskin <proski@gnu.org>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100418085653.GA7345@linux-m68k.org>
References: <20100418085653.GA7345@linux-m68k.org>
Content-Type: text/plain
Date: Mon, 19 Apr 2010 12:34:15 -0400
Message-Id: <1271694855.9026.51.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-04-18 at 10:56 +0200, Richard Zidlicky wrote:
> Hi,
> 
> I am getting tons of these http://www.kerneloops.org/submitresult.php?number=3048061,
> appears every packet triggers that.

The warning comes from the function rix_to_ndx() in rc80211_minstrel.c:

/* convert mac80211 rate index to local array index */
static inline int
rix_to_ndx(struct minstrel_sta_info *mi, int rix)
{
        int i = rix;
        for (i = rix; i >= 0; i--)
                if (mi->r[i].rix == rix)
                        break;
        WARN_ON(i < 0);
        return i;
}

> Can provide lots of debugging info.

My impression is that WARN_ON is not warranted in that function, but it
would be interesting to know how you got to that point.

What driver are you using?  What is the mode for the interface? What is
your hardware?  Is there anything unusual you do that triggers the
warning?  Are you using 5 GHz band by any chance?  Are you using
2.6.34-rc4 or it's compat-wireless compiled for another kernel?

-- 
Regards,
Pavel Roskin
