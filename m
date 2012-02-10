Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab2BJMBF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Feb 2012 07:01:05 -0500
Date: Fri, 10 Feb 2012 13:01:02 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/4] iwlwifi: dump stack when fail to gain access to the
 device
Message-ID: <20120210120101.GB2274@redhat.com> (sfid-20120210_130110_421794_442E7070)
References: <1328544564-8696-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1328544564-8696-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 06, 2012 at 05:09:21PM +0100, Stanislaw Gruszka wrote:
> Print dump stack when the device is not responding. This should give
> some more clue about the reason of failure. Also change the message we
> print, since "MAC in deep sleep" is kinda confusing.
> 
> On the way add unlikely(), as fail to gain NIC access is hmm ...
> unlikely.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-io.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
> index 83fdff3..ce6d9c1 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-io.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-io.c
> @@ -120,10 +120,10 @@ int iwl_grab_nic_access_silent(struct iwl_bus *bus)
>  int iwl_grab_nic_access(struct iwl_bus *bus)
>  {
>  	int ret = iwl_grab_nic_access_silent(bus);
> -	if (ret) {
> +	if (unlikely(ret)) {
>  		u32 val = iwl_read32(bus, CSR_GP_CNTRL);
> -		IWL_ERR(bus,
> -			"MAC is in deep sleep!. CSR_GP_CNTRL = 0x%08X\n", val);
> +		WARN_ONCE(1, "Timeout waiting for ucode processor access "
> +			     "(CSR_GP_CNTRL 0x%08x)\n", val);
>  	}
I need to do a bit more testing before posting this. On iwlegacy the waring is
triggered on rfkill, and currently I have no access to iwlwifi with rfkill
switch, but seems there will be the same problem with iwlwifi: iwl_grab_nic_access()
fail when rfkill is on.

Stanislaw
