Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61358 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab0C3SG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 14:06:58 -0400
Received: by pwi5 with SMTP id 5so7986031pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 11:06:57 -0700 (PDT)
Message-ID: <4BB23DBD.8080904@lwfinger.net>
Date: Tue, 30 Mar 2010 13:06:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [RFC][PATCH][WIP] b43: N-PHY: set band width
References: <1269971657-4663-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1269971657-4663-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/2010 12:54 PM, Rafał Miłecki wrote:
> ---
> I've problem with deciding how to keep some data needed by band width setting
> code. Generally these band width-related routines are considered "common", to
> be used by more than just N-PHY. So probably the most /correct/ way should be
> to add some variables like maccontrol, wake_override, clk and other to struct
> b43_phy which is shared between all PHYs. However we would not use these vars
> in anything except N-PHY, so we would just waste users memory.
> 
> Could you help me decide correct way to handle this?

I have not done the RE yet, but the SSLPN PHY is multi-band and will likely need
all the band width parameters needed by the N PHY. I would vote for putting them
in a "common" struct.

Larry
