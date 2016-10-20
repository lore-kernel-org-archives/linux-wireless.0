Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45047 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933643AbcJTNcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Oct 2016 09:32:04 -0400
Message-ID: <1476970318.4929.32.camel@sipsolutions.net> (sfid-20161020_153207_974363_0D5B7A45)
Subject: Re: [PATCH 10/10] iwlwifi: mvm: use dev_coredumpsg()
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Aviya Erenfeld <aviya.erenfeld@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 20 Oct 2016 15:31:58 +0200
In-Reply-To: <20161019100755.23874-11-luca@coelho.fi> (sfid-20161019_171834_075034_345D0F62)
References: <20161019100755.23874-1-luca@coelho.fi>
         <20161019100755.23874-11-luca@coelho.fi>
         (sfid-20161019_171834_075034_345D0F62)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -	dev_coredumpm(mvm->trans->dev, THIS_MODULE, fw_error_dump,
> 0,
> -		      GFP_KERNEL, iwl_mvm_read_coredump,
> iwl_mvm_free_coredump);
> +	sg_dump_data = alloc_sgtable(file_len);
> +	if (sg_dump_data) {
> +		sg_pcopy_from_buffer(sg_dump_data,
> +				     sg_nents(sg_dump_data),
> +				     fw_error_dump->op_mode_ptr,
> +				     fw_error_dump->op_mode_len, 0);
> +		sg_pcopy_from_buffer(sg_dump_data,
> +				     sg_nents(sg_dump_data),
> +				     fw_error_dump->trans_ptr->data,
> +				     fw_error_dump->trans_ptr->len,
> +				     fw_error_dump->op_mode_len);
> 
smatch pointed out that we check fw_error_dump->trans_ptr for NULL
earlier, and that is indeed correct afaict; I've sent you a fix
internally :)

johannes
