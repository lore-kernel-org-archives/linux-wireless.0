Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46049 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaJ0RpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 13:45:11 -0400
Date: Mon, 27 Oct 2014 13:31:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Harris <harmic@gmail.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] wireless-regdb: Update rules for Australia (AU) to
 align with class licence
Message-ID: <20141027173141.GB28300@tuxdriver.com> (sfid-20141027_184526_067649_D4E923CD)
References: <1413111411-29509-1-git-send-email-harmic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413111411-29509-1-git-send-email-harmic@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm always a bit cautious about merging regdb patches that loosen
the rules.  Would anyone with more expertise on such regulations care
to comment on this one?

On Sun, Oct 12, 2014 at 09:56:51PM +1100, Michael Harris wrote:
> I am not sure where the existing regdb rules for Australia were derived from
> (perhaps some default template?) but they are a lot more restrictive than the
> actual class licence requirements.
> 
> I have updated to the best of my ability according to the "Radiocommunications
> (Low Interference Potential Devices) Class Licence 2000" which can be found here:
> 
> http://www.acma.gov.au/Industry/Spectrum/Radiocomms-licensing/Class-licences/class-licences
> 
> There is also a useful FAQ for 2.4GHz WLANs here:
> http://www.acma.gov.au/Citizen/Consumer-info/My-connected-home/Wireless-local-area-networks/wireless-lans-in-the-24-ghz-band-faqs
> 
> Signed-off-by: Michael Harris <harmic@gmail.com>
> ---
>  db.txt | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/db.txt b/db.txt
> index f0e4312..94c7010 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -78,12 +78,22 @@ country AT: DFS-ETSI
>  	# 60 gHz band channels 1-4, ref: Etsi En 302 567
>  	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
>  
> +# Reference: Radiocommunications (Low Interference Potential Devices) Class Licence 2000
> +# http://www.acma.gov.au/Industry/Spectrum/Radiocomms-licensing/Class-licences/class-licences
>  country AU:
> -	(2402 - 2482 @ 40), (20)
> -	(5170 - 5250 @ 80), (17)
> -	(5250 - 5330 @ 80), (24), DFS
> -	(5490 - 5710 @ 80), (24), DFS
> -	(5735 - 5835 @ 80), (30)
> +	# Item 45A
> +	(2400 - 2483 @ 40), (36)
> +	# Item 44
> +	(5150 - 5250 @ 80), (23), NO-OUTDOOR
> +	# Item 44A (assuminging no TPC implemented).
> +	# If TPC implemented then 23dBm allowed.
> +	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS
> +	# Item 46 (assuming no TPC implemented)
> +	# If TPC implemented then 30dBm allowed
> +	(5470 - 5600 @ 80), (27), DFS
> +	(5650 - 5725 @ 40), (27), DFS
> +	# Item 45B
> +	(5725 - 5850 @ 80), (36)
>  
>  country AW: DFS-ETSI
>  	(2402 - 2482 @ 40), (20)
> -- 
> 1.8.3.1
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
