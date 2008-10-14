Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51448 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbYJNPoR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 11:44:17 -0400
Subject: Re: [PATCH] ipw2200: Change driver default policies
From: Dan Williams <dcbw@redhat.com>
To: Tim Gardner <timg@tpi.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081014145708.CAF215A1D8@sepang.rtg.net>
References: <20081014145708.CAF215A1D8@sepang.rtg.net>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 11:43:12 -0400
Message-Id: <1223998992.3936.28.camel@localhost.localdomain> (sfid-20081014_174424_378190_B06634FB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-14 at 08:57 -0600, Tim Gardner wrote:
> From 41804698de6f2ce121c1452943b9ad2b8a54988b Mon Sep 17 00:00:00 2001
> From: Tim Gardner <tim.gardner@canonical.com>
> Date: Tue, 14 Oct 2008 08:16:09 -0600
> Subject: [PATCH] ipw2200: change default policies for auto-associate, auto-create, and auto-roaming
> 
> We now have applications available to set policy. This patch changes the driver defaults to:
> 
> 1) associate=0 - do not automatically associate to an SSID.

This one is fine.

> 2) auto_create=0 - do not automatically create an ad-hoc network

This will break adhoc network creation, thus NAK.  I think we should
just remove the module parameter and default to 1 anyway.  This is the
way adhoc _should_ work in the first place, if the adhoc network you're
attempting to join does not yet exist, the driver should create that
network.  This is the way it works for all other drivers as well.

Disabling this effectively means you can only join existing adhoc
networks, not start your own.

> 3) roaming=0 - do not automatically roam to another AP with the same SSID.

Not really sure why this should be changed?  Were there reported issues
with this behavior?

Dan

> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  Documentation/networking/README.ipw2200 |    6 +++---
>  drivers/net/wireless/ipw2200.c          |    6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/networking/README.ipw2200 b/Documentation/networking/README.ipw2200
> index 4f2a40f..8f3e40d 100644
> --- a/Documentation/networking/README.ipw2200
> +++ b/Documentation/networking/README.ipw2200
> @@ -147,14 +147,14 @@ Where the supported parameter are:
>  	driver.  If disabled, the driver will not attempt to scan 
>  	for and associate to a network until it has been configured with 
>  	one or more properties for the target network, for example configuring 
> -	the network SSID.  Default is 1 (auto-associate)
> +	the network SSID.  Default is 0 (do not auto-associate)
>  	
> -	Example: % modprobe ipw2200 associate=0
> +	Example: % modprobe ipw2200 associate=1
>  
>    auto_create
>  	Set to 0 to disable the auto creation of an Ad-Hoc network 
>  	matching the channel and network name parameters provided.  
> -	Default is 1.
> +	Default is 0.
>  
>    channel
>  	channel number for association.  The normal method for setting
> diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
> index dcce354..31f396b 100644
> --- a/drivers/net/wireless/ipw2200.c
> +++ b/drivers/net/wireless/ipw2200.c
> @@ -87,13 +87,13 @@ static int channel = 0;
>  static int mode = 0;
>  
>  static u32 ipw_debug_level;
> -static int associate = 1;
> -static int auto_create = 1;
> +static int associate;
> +static int auto_create;
>  static int led = 0;
>  static int disable = 0;
>  static int bt_coexist = 0;
>  static int hwcrypto = 0;
> -static int roaming = 1;
> +static int roaming;
>  static const char ipw_modes[] = {
>  	'a', 'b', 'g', '?'
>  };

