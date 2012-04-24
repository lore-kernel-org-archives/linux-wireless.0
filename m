Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56132 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2DXFuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 01:50:19 -0400
Message-ID: <1335246611.3447.0.camel@jlt3.sipsolutions.net> (sfid-20120424_075024_156171_2DA33BEC)
Subject: Re: [PATCH 1/2] wireless: properly use pr_fmt()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 24 Apr 2012 07:50:11 +0200
In-Reply-To: <1335234998-31547-1-git-send-email-mcgrof@frijolero.org> (sfid-20120424_043650_596999_863DFBA6)
References: <1335234998-31547-1-git-send-email-mcgrof@frijolero.org>
	 (sfid-20120424_043650_596999_863DFBA6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-23 at 19:36 -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
> 
> pr_fmt() is either defined or we redefine it. Typically
> drivers define it prior to including printk.h but this
> is done under the assumption that no other subsystem
> it uses has already defined pr_fmt(). In such cases
> pr_fmt() should be undefined and redefined.
> 
> Doing this properly shaves down compilation time quite
> considerably.

> --- a/drivers/net/wireless/ath/ath5k/ani.c
> +++ b/drivers/net/wireless/ath/ath5k/ani.c
> @@ -14,8 +14,11 @@
>   * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>   */
>  
> +#undef pr_fmt
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

I understand this is right for compat, but is it really also needed in
mainline? I was under the impression there we never defined pr_fmt in
header files.

johannes

