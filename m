Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:19763 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751744AbXERUMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 16:12:42 -0400
Message-ID: <464DF7FC.5070702@linux.intel.com>
Date: Fri, 18 May 2007 12:01:16 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <20070516182700.912a21ed.randy.dunlap@oracle.com>
In-Reply-To: <20070516182700.912a21ed.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Randy Dunlap wrote:
>> 	http://intellinuxwireless.org/iwlwifi/0001-Add-iwlwifi-wireless-drivers.patch
> Some comments/review, mostly not-code-related:
> 

Here is the current status (everything not described below has been fixed in GIT, and is available in the patch at http://intellinuxwireless.org/iwlwifi/0001-v2-Add-iwlwifi-wireless-drivers.patch:

> 2.  Convert function comment blocks into kernel-doc.  E.g., this one:
Fixed this part.
...
> Preferably at least all non-static functions will be documented
> with kernel-doc.

I updated and added some of these.  Improving the kernel-doc (and comments in general) over time is on the list of things to do.

> 14.  sysfs files should contain only 1 value.  Compare
> 
> +static ssize_t show_tune(struct device *d,
> +			 struct device_attribute *attr, char *buf)
> +{
> +	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
> +
> +	return sprintf(buf, "%d %d\n",
> +		       priv->phymode, priv->active_rxon.channel);
> +}
> 
> and show_channels()  [probably others].

I've modified show/store_tune to take and return a single value encoding the band and channel (since they are locked together and can't be set separately without introducing temporary state logic; tuning to channel 6 could be done in the 2.4GHz band or the 5.2GHz band)

I've added fixing show_channels to the list of things to change; the approach currently used has been *very* useful, without any additional tools or scripts, to be able to just cat a file and see the supported channel map by the driver.  Having to do an ls on a directory to see the bands, and within each band to do an ls to see the channels, and within each channel to then have a single flags attribute seems painful from a system overhead as well as usability standpoint (although making a graphical tool on top of it would be easier...)

We also need to look at cleaning up / fixing how the measurement requests can be performed, etc.  

The power_level sysfs attribute currently has a single parameter for setting it, and in showing it it provides back the single parameter and a text translation with additional information about the setting.  Ex (with a slight change I committed vs. what was in the original patch):

% echo 3 > /sys/bus/pci/drivers/iwl3945/*/power_level
% cat /sys/bus/pci/drivers/iwl3945/*/power_level
3 (Timeout 75ms, Period 1000ms)

> 15.  Limit source lines to <= 80 columns (this patch contains
> over 200 lines that are > 80 columns).

Fixed in the .c files.  Still have 155 instances in the .h files (most due to mid-line tabs)

---

Are you OK with iwlwifi addressing the above post-merge into wireless-dev?

James
