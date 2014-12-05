Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54355 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaLEQpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2014 11:45:23 -0500
Date: Fri, 5 Dec 2014 11:33:53 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless-regdb: Update keys and maintainer information
Message-ID: <20141205163353.GC28319@tuxdriver.com> (sfid-20141205_174527_928187_DED8251B)
References: <20141205163134.GC13629@ubuntu-mba51>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141205163134.GC13629@ubuntu-mba51>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 05, 2014 at 10:31:34AM -0600, Seth Forshee wrote:
> As announced by John [1], I'm taking over maintaintership of the
> wireless regulatory databse. Make it official by adding my key,
> removing John's, and updating the Makefile and documentation to
> reflect the change in maintainer.
> 
> [1] http://permalink.gmane.org/gmane.linux.kernel.wireless.general/131573
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

ACK

Although, I would have changed "In linville we trust" to "In Seth we
trust"... ;-)

John

> ---
>  Makefile               | 3 +--
>  debian-example/control | 2 +-
>  linville.key.pub.pem   | 9 ---------
>  sforshee.key.pub.pem   | 9 +++++++++
>  wireless-regdb.spec    | 2 +-
>  5 files changed, 12 insertions(+), 13 deletions(-)
>  delete mode 100644 linville.key.pub.pem
>  create mode 100644 sforshee.key.pub.pem
> 
> diff --git a/Makefile b/Makefile
> index 3d5040d..907ff28 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -32,7 +32,7 @@ REGDB_AUTHOR ?= $(shell if [ -f $(DISTRO_PRIVKEY) ]; then \
>  REGDB_PRIVKEY ?= ~/.wireless-regdb-$(REGDB_AUTHOR).key.priv.pem
>  REGDB_PUBKEY ?= $(REGDB_AUTHOR).key.pub.pem
>  
> -REGDB_UPSTREAM_PUBKEY ?= linville.key.pub.pem
> +REGDB_UPSTREAM_PUBKEY ?= sforshee.key.pub.pem
>  
>  REGDB_CHANGED = $(shell $(SHA1SUM) -c --status sha1sum.txt >/dev/null 2>&1; \
>          if [ $$? -ne 0 ]; then \
> @@ -103,7 +103,6 @@ install: regulatory.bin.5.gz
>  	if [ -f .custom ]; then \
>  		install -m 644 -t $(DESTDIR)/$(CRDA_KEY_PATH)/ $(shell cat .custom); \
>  	fi
> -	@# In linville we trust
>  	install -m 644 -t $(DESTDIR)/$(CRDA_KEY_PATH)/ $(REGDB_UPSTREAM_PUBKEY)
>  	install -m 644 -t $(DESTDIR)/$(CRDA_PATH)/ regulatory.bin
>  	install -m 755 -d $(DESTDIR)/$(MANDIR)/man5/
> diff --git a/debian-example/control b/debian-example/control
> index a5b518b..e6e7161 100644
> --- a/debian-example/control
> +++ b/debian-example/control
> @@ -12,4 +12,4 @@ Suggests: crda
>  Description: The Linux wireless regulatory database
>   This package contains the wireless regulatory database used by all
>   cfg80211 based Linux wireless drivers. The wireless database being
> - used is maintained by John Linville, the Linux wireless kernel maintainer.
> + used is maintained by Seth Forshee.
> diff --git a/linville.key.pub.pem b/linville.key.pub.pem
> deleted file mode 100644
> index 3a2e8d0..0000000
> --- a/linville.key.pub.pem
> +++ /dev/null
> @@ -1,9 +0,0 @@
> ------BEGIN PUBLIC KEY-----
> -MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1leZcYjTXc4qLq1oN2Ak
> -8vLP85P5cFTrCpqdSI5W4VOwdaJB4TtaxU2fATcH/A2EsE3h1rOfzI0+fBV9DcOO
> -qyID+zdILBMb8xK5Zv+78OkBGls/WzvDDVhdmn1TRHvRvmJy7cX1mCT56cnHrZM/
> -ZBaFwVfiD9TcqqisyF1sqE5+cMHTWRbxc1+rtojr0eGYrNfK20awlD5KVj6Ejzot
> -r9EDWAsL1bH/kGfMdnputcyMapLQpRVruO/jEdjSmhAE/sj1tmHcAXBT6j5al4Oa
> -LiBaWnP++rune7rjimwfzp0549/rupQUM7nAZRDLyzXj3J/KEci6dXtjonBUFqDY
> -4QIDAQAB
> ------END PUBLIC KEY-----
> diff --git a/sforshee.key.pub.pem b/sforshee.key.pub.pem
> new file mode 100644
> index 0000000..73d580e
> --- /dev/null
> +++ b/sforshee.key.pub.pem
> @@ -0,0 +1,9 @@
> +-----BEGIN PUBLIC KEY-----
> +MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtUDjnCiEOQPyOddmLEE4
> +Fax+pYNxJX6QfGjdbz/Z11k4n3xqUsIDKi1+ZvQesxJwIFvUlzI9cYs7GwgXFGth
> +xFeLlhYc/STVCwn5aBGE+8pRDNFFGdoQRIrZ/nap/WAtGAsolbIt6oiYuNFWIfBT
> +H/ECb+lGm5NfKJAPrDb6aCNxV1b2zNPffSrZG3NF67onhe96f6XLgMcwNtJT7uys
> +Hucx8TainGPGZVt/JXVooerTfgBcml7YIBgydwcpEmYeNnPnlwRBN7Gxciv0oSkg
> +fJZ5CyvQ2N7IbD+T+8XueFIRFRt69uJomef7RhaE48eh5uDSRtXhxF+gZvTaxP+V
> +HQIDAQAB
> +-----END PUBLIC KEY-----
> diff --git a/wireless-regdb.spec b/wireless-regdb.spec
> index b76d391..bb648ca 100644
> --- a/wireless-regdb.spec
> +++ b/wireless-regdb.spec
> @@ -16,7 +16,7 @@ BuildArch: noarch
>  %description
>  This package contains the wireless regulatory database used by all
>  cfg80211 based Linux wireless drivers. The wireless database being
> -used is maintained by John Linville, the Linux wireless kernel maintainer
> +used is maintained by Seth Forshee.
>  http://wireless.kernel.org/en/developers/Regulatory/
>  
>  %prep
> -- 
> 1.9.1



-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
