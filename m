Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbYG0PMq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 11:12:46 -0400
Subject: Re: [PATCH 3/3 RESEND] libertas: check bounds and only use decimal
	for sysfs persistent features.
From: Dan Williams <dcbw@redhat.com>
To: Brian Cavagnolo <brian@cozybit.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <4884d9ea.01f6600a.4611.ffffe84f@mx.google.com>
References: <4884d9ea.01f6600a.4611.ffffe84f@mx.google.com>
Content-Type: text/plain
Date: Sun, 27 Jul 2008 11:10:28 -0400
Message-Id: <1217171428.2700.19.camel@localhost.localdomain> (sfid-20080727_171248_291865_97164CE0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-07-21 at 11:04 -0700, Brian Cavagnolo wrote:
> Some persistent settings were using hex and others decimal.  In some cases,
> values were set in hex but reported in decimal.  Confusing.
> 
> Signed-off-by: Brian Cavagnolo <brian@cozybit.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/persistcfg.c |   30 ++++++++++++++--------------
>  1 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/persistcfg.c b/drivers/net/wireless/libertas/persistcfg.c
> index 6d0ff8d..3309a9c 100644
> --- a/drivers/net/wireless/libertas/persistcfg.c
> +++ b/drivers/net/wireless/libertas/persistcfg.c
> @@ -48,7 +48,7 @@ static ssize_t bootflag_get(struct device *dev,
>  	if (ret)
>  		return ret;
>  
> -	return snprintf(buf, 12, "0x%x\n", le32_to_cpu(defs.bootflag));
> +	return snprintf(buf, 12, "%d\n", le32_to_cpu(defs.bootflag));
>  }
>  
>  /**
> @@ -63,8 +63,8 @@ static ssize_t bootflag_set(struct device *dev, struct device_attribute *attr,
>  	int ret;
>  
>  	memset(&cmd, 0, sizeof(cmd));
> -	ret = sscanf(buf, "%x", &datum);
> -	if (ret != 1)
> +	ret = sscanf(buf, "%d", &datum);
> +	if ((ret != 1) || (datum > 1))
>  		return -EINVAL;
>  
>  	*((__le32 *)&cmd.data[0]) = cpu_to_le32(!!datum);
> @@ -91,7 +91,7 @@ static ssize_t boottime_get(struct device *dev,
>  	if (ret)
>  		return ret;
>  
> -	return snprintf(buf, 12, "0x%x\n", defs.boottime);
> +	return snprintf(buf, 12, "%d\n", defs.boottime);
>  }
>  
>  /**
> @@ -106,8 +106,8 @@ static ssize_t boottime_set(struct device *dev,
>  	int ret;
>  
>  	memset(&cmd, 0, sizeof(cmd));
> -	ret = sscanf(buf, "%x", &datum);
> -	if (ret != 1)
> +	ret = sscanf(buf, "%d", &datum);
> +	if ((ret != 1) || (datum > 255))
>  		return -EINVAL;
>  
>  	/* A too small boot time will result in the device booting into
> @@ -143,7 +143,7 @@ static ssize_t channel_get(struct device *dev,
>  	if (ret)
>  		return ret;
>  
> -	return snprintf(buf, 12, "0x%x\n", le16_to_cpu(defs.channel));
> +	return snprintf(buf, 12, "%d\n", le16_to_cpu(defs.channel));
>  }
>  
>  /**
> @@ -154,11 +154,11 @@ static ssize_t channel_set(struct device *dev, struct device_attribute *attr,
>  {
>  	struct lbs_private *priv = to_net_dev(dev)->priv;
>  	struct cmd_ds_mesh_config cmd;
> -	uint16_t datum;
> +	uint32_t datum;
>  	int ret;
>  
>  	memset(&cmd, 0, sizeof(cmd));
> -	ret = sscanf(buf, "%hx", &datum);
> +	ret = sscanf(buf, "%d", &datum);
>  	if (ret != 1 || datum < 1 || datum > 11)
>  		return -EINVAL;
>  
> @@ -274,8 +274,8 @@ static ssize_t protocol_id_set(struct device *dev,
>  	int ret;
>  
>  	memset(&cmd, 0, sizeof(cmd));
> -	ret = sscanf(buf, "%x", &datum);
> -	if (ret != 1)
> +	ret = sscanf(buf, "%d", &datum);
> +	if ((ret != 1) || (datum > 255))
>  		return -EINVAL;
>  
>  	/* fetch all other Information Element parameters */
> @@ -328,8 +328,8 @@ static ssize_t metric_id_set(struct device *dev, struct device_attribute *attr,
>  	int ret;
>  
>  	memset(&cmd, 0, sizeof(cmd));
> -	ret = sscanf(buf, "%x", &datum);
> -	if (ret != 1)
> +	ret = sscanf(buf, "%d", &datum);
> +	if ((ret != 1) || (datum > 255))
>  		return -EINVAL;
>  
>  	/* fetch all other Information Element parameters */
> @@ -382,8 +382,8 @@ static ssize_t capability_set(struct device *dev, struct device_attribute *attr,
>  	int ret;
>  
>  	memset(&cmd, 0, sizeof(cmd));
> -	ret = sscanf(buf, "%x", &datum);
> -	if (ret != 1)
> +	ret = sscanf(buf, "%d", &datum);
> +	if ((ret != 1) || (datum > 255))
>  		return -EINVAL;
>  
>  	/* fetch all other Information Element parameters */

