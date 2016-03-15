Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:33024 "EHLO
	mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbcCOOda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 10:33:30 -0400
Received: by mail-yw0-f178.google.com with SMTP id d65so22803402ywb.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2016 07:33:29 -0700 (PDT)
Subject: Re: linux-4.5/drivers/net/wireless/broadcom/b43/phy_lp.c: 1851: maybe
 uninit data ?
To: David Binderman <dcb314@hotmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
References: <DUB128-W5980055F8A15A7CABF8D689C890@phx.gbl>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56E81D36.60004@lwfinger.net> (sfid-20160315_153333_360759_F742DED3)
Date: Tue, 15 Mar 2016 09:33:26 -0500
MIME-Version: 1.0
In-Reply-To: <DUB128-W5980055F8A15A7CABF8D689C890@phx.gbl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/2016 05:50 AM, David Binderman wrote:
> Hello there,
>
> [linux-4.5/drivers/net/wireless/broadcom/b43/phy_lp.c:1851]: (error) Uninitialized struct member: gains.gm
> [linux-4.5/drivers/net/wireless/broadcom/b43/phy_lp.c:1851]: (error) Uninitialized struct member: gains.pga
> [linux-4.5/drivers/net/wireless/broadcom/b43/phy_lp.c:1851]: (error) Uninitialized struct member: gains.pad
> [linux-4.5/drivers/net/wireless/broadcom/b43/phy_lp.c:1851]: (error) Uninitialized struct member: gains.dac
>
> [linux-4.5/drivers/net/wireless/broadcom/b43/phy_lp.c:1853]: (error) Uninitialized struct member: gains.gm
> [linux-4.5/drivers/net/wireless/broadcom/b43/phy_lp.c:1853]: (error) Uninitialized struct member: gains.pga
> [linux-4.5/drivers/net/wireless/broadcom/b43/phy_lp.c:1853]: (error) Uninitialized struct member: gains.pad
> [linux-4.5/drivers/net/wireless/broadcom/b43/phy_lp.c:1853]: (error) Uninitialized struct member: gains.dac
>
> I've had a look at the code and I can't see how local structure 'gains' get initialised.

It does not get initialized; however, it is only used in calls to 
lpphy_papd_cal() that does nothing. Thus, no harm, no foul.

You should prepare a patch that initializes it to zero in line 1837.

Larry


