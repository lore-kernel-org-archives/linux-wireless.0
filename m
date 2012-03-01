Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:46936 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965106Ab2CAVmV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 16:42:21 -0500
Received: by obbuo6 with SMTP id uo6so882805obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2012 13:42:20 -0800 (PST)
Message-ID: <4F4FED4E.2010000@lwfinger.net> (sfid-20120301_224225_602250_302A42C1)
Date: Thu, 01 Mar 2012 15:42:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Saul St. John" <saul.stjohn@gmail.com>,
	Rafal Milecki <zajec5@gmail.com>
Subject: Re: [RFC] bcma: add support for on-chip OTP memory used for SPROM
 storage
References: <1330033977-5741-1-git-send-email-arend@broadcom.com> <4F48D997.1060400@hauke-m.de> <4F4B571E.7040704@broadcom.com> <4F4FE989.3090108@broadcom.com>
In-Reply-To: <4F4FE989.3090108@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/01/2012 03:26 PM, Arend van Spriel wrote:
>
> SPEX(board_rev, SSB_SPROM8_BOARDREV, ~0, 0);
>
> SPEX(txpid2g[0], SSB_SPROM4_TXPID2G01, SSB_SPROM4_TXPID2G0,
> SSB_SPROM4_TXPID2G0_SHIFT);
> SPEX(txpid2g[1], SSB_SPROM4_TXPID2G01, SSB_SPROM4_TXPID2G1,
> SSB_SPROM4_TXPID2G1_SHIFT);
>
> The attributes txpid2g that are filled here are deprecated for srom revision 8.
> Is b43 using these fields for boards with srom rev 8?
>
> I propose to move to BCMA having its own sprom structure definition. Srom
> revision 10 is upcoming and it does only apply to BCMA-based cards.

If there will be SPROM revisions that are not appropriate for SSB, then BCMA 
should likely have its own definition.

Those attributes that are deprecated for Rev 8 are there because we had no way 
to know that they were being eliminated. That was not apparent when doing the 
reverse engineering.

Larry
