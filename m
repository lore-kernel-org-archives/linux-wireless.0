Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44108 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1K1Sal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 13:30:41 -0500
Date: Mon, 28 Nov 2011 13:19:12 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	Robert =?iso-8859-1?Q?Gr=F8nning?= <slimg@iggu.org>
Subject: Re: wireless-regdb: Update regulatory rules for Norway (NO)
Message-ID: <20111128181912.GB2681@tuxdriver.com> (sfid-20111128_193044_563413_DA41524F)
References: <87pqgkxn25.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <87pqgkxn25.fsf@nemi.mork.no>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Any comments from the regulatory experts in the group?

On Tue, Nov 22, 2011 at 03:13:22PM +0100, Bjørn Mork wrote:
> As mentioned by Robert Grønning <slimg at iggu.org> in June, Norway does
> allow a few more bands than what's currently in the database.  In
> particular, the old ISM band at 5725 - 5875 MHz is and has "always" been
> allowed.
> 
> The regulations [1] have some weird restrictions wrt power densities etc
> which I have no idea how to describe in a format suitable for the db.
> I've tried my best to make sure the entries are within the rules.
> 
> The regulations also allow up to 1 W eirp in the band 5470 - 5725 MHz,
> and up to 4 W eirp in the bands 5725 - 5795 MHz and 5815 - 5850 MHz if
> TPC is in use. The limits are reduced by 3dB without TPC.  As I don't
> know how to express the TPC requirement, I've chosen to put the reduced
> limits (500 mW and 2 W) in the db entries.  This also matches the German
> (DE) entry for 5470 - 5725 MHz, so I guess it must make some sense...
> 
> I also have no idea which SI prefixes you allow in the database, so I've
> used whatever was in the regulations.  Please adjust as needed if only
> mW or dB is acceptable.  Or let me know and I'll provide an updated patch.
> 
> 
> Patch attached.
> 
> 
> 
> 
> References:
> 
> [1] Current Norwegian regulations:
>   http://www.lovdata.no/cgi-wift/ldles?doc=/sf/sf/sf-20090602-0580.html
> 
> [2] The Norwegian Post and Telecommunications Authority provides an unofficial english translation of these regulations:
>   http://www.npt.no/ikbViewer/Content/103810/Regulations_concerning_general_authorisations_for_the_use_of_radio_frequencies.pdf
> 
> 
> [3] Appendix 1 of ERC/REC 70-03 provides generic information about licensing
>   status for Short Range Devices (SRD) in most CEPT countries:
>   http://www.ecodocdb.dk/doks/filedownload.aspx?fileid=1694&fileurl=http://www.erodocdb.dk/Docs/doc98/official/pdf/REC7003E.PDF
> 
> 
> 
> 
> Bjørn

> diff --git a/db.txt b/db.txt
> index e63a43e..375187f 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -469,11 +469,20 @@ country NL:
>  	(5250 - 5330 @ 40), (N/A, 20), DFS
>  	(5490 - 5710 @ 40), (N/A, 27), DFS
>  
> +# Data from http://www.lovdata.no/cgi-wift/ldles?doc=/sf/sf/sf-20090602-0580.html
>  country NO:
> -	(2402 - 2482 @ 40), (N/A, 20)
> -	(5170 - 5250 @ 40), (N/A, 20)
> -	(5250 - 5330 @ 40), (N/A, 20), DFS
> -	(5490 - 5710 @ 40), (N/A, 27), DFS
> +	# § 7 (2)
> +	(2400 - 2483.5 @ 40), (N/A, 100 mW)
> +	# § 7 (3)
> +	(5150 - 5350 @ 40), (N/A, 200 mW)
> +	# § 7 (4)
> +	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
> +	# § 7 (5)
> +	(5725 - 5795 @ 40), (N/A, 2 W), DFS
> +	(5815 - 5850 @ 40), (N/A, 2 W), DFS
> +	# § 7 (6)
> +	(5725 - 5795 @ 40), (23, 1 W), DFS, PTP-ONLY
> +	(5815 - 5850 @ 40), (23, 1 W), DFS, PTP-ONLY
>  
>  country NP:
>  	(2402 - 2482 @ 40), (N/A, 20)


-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
