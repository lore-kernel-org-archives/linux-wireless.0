Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36630 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764849AbYETOMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 10:12:03 -0400
Subject: Re: [PATCH 2/2] Sysfs interface for accessing non-volatile
	configuration.
From: David Woodhouse <dwmw2@infradead.org>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	carrano@laptop.org, dilinger@queued.net
In-Reply-To: <4832422a.20018e0a.6b37.3217@mx.google.com>
References: <4832422a.20018e0a.6b37.3217@mx.google.com>
Content-Type: text/plain
Date: Tue, 20 May 2008 15:11:58 +0100
Message-Id: <1211292718.21380.238.camel@pmac.infradead.org> (sfid-20080520_161226_497075_088F5D51)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-05-17 at 21:01 -0700, Javier Cardona wrote:
> @@ -1218,6 +1219,7 @@ int lbs_start_card(struct lbs_private *priv)
>         if (device_create_file(&dev->dev, &dev_attr_lbs_rtap))
>                 lbs_pr_err("cannot register lbs_rtap attribute\n");
>  
> +       lbs_persist_config_init(dev);
>         lbs_update_channel(priv);
>  
>         /* 5.0.16p0 is known to NOT support any mesh */
> @@ -1278,6 +1280,7 @@ int lbs_stop_card(struct lbs_private *priv)
>  
>         lbs_debugfs_remove_one(priv);
>         device_remove_file(&dev->dev, &dev_attr_lbs_rtap);
> +       lbs_persist_config_remove(dev);
>         if (priv->mesh_tlv)
>                 device_remove_file(&dev->dev, &dev_attr_lbs_mesh);
>  

As Holger points out, we should call those only if (priv->mesh_tlv).

> +	return snprintf(buf, 12, "0x%X\n",
> +		le32_to_cpu(cpu_to_le32(defs.bootflag)));

Que? Sparse loves that one :)

> +	*((uint32_t *)&cmd.data[0]) = cpu_to_le32(!!datum);

Sparse doesn't much like that either. It should be (__le32 *)

> +static ssize_t boottime_get(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct lbs_private *priv = to_net_dev(dev)->priv;
> +	struct cmd_ds_mesh_config cmd;
> +	struct mrvl_mesh_defaults *defs;
> +	int ret;
> +
> +	memset(&cmd, 0, sizeof(struct cmd_ds_mesh_config));
> +	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_GET,
> +			CMD_TYPE_MESH_GET_DEFAULTS);
> +
> +	if (ret)
> +		return -EOPNOTSUPP;

Why not using mesh_get_default_parameters()? 

> +	/* A too small boot time will result in the device booting into
> +	 * standalone (no-host) mode before the host can take control of it,
> +	 * so the change will be hard to revert.  This may be a desired
> +	 * feature (e.g to configure a very fast boot time for devices that
> +	 * will not be attached to a host), but dangerous.  So I'm enforcing a
> +	 * lower limit of 20 seconds:  remove and recompile the driver if this
> +	 * does not work for you.
> +	 */
> +	datum = (datum < 20) ? 20 : datum;

Hm. The driver should be able to cope with a device which is already
booted -- it sends it a reset command and then initialises it. I don't
think we have to be so paranoid, do we? If there's a lower limit on the
boottime, it would be the time it takes for an already-active driver to
react when the device resets. Which is much less than 20 seconds.

-- 
dwmw2

