Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f68.google.com ([209.85.192.68]:36615 "EHLO
	mail-qg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbcAZXSF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 18:18:05 -0500
Received: by mail-qg0-f68.google.com with SMTP id 6so13381716qgy.3
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2016 15:18:04 -0800 (PST)
Date: Tue, 26 Jan 2016 18:17:59 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Henning Rogge <hrogge@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: Re: [PATCH 2/2] mac80211: let unused MPP table entries timeout
Message-ID: <20160126231759.GA9708@localhost> (sfid-20160127_001809_830416_E5928484)
References: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1453190672-9748-3-git-send-email-henning.rogge@fkie.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453190672-9748-3-git-send-email-henning.rogge@fkie.fraunhofer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 19, 2016 at 09:04:32AM +0100, Henning Rogge wrote:
>  	err = -ENXIO;
> -enddel:
> +enddelpath:

Concur about it being better to leave this label alone, also the diff looks
weird because it continues:

> +	mesh_paths_generation++;
> +	spin_unlock(&tbl->hashwlock[hash_idx]);
> +	read_unlock_bh(&pathtbl_resize_lock);
> +	return err;
> +}

[...]

> +	err = -ENXIO;
> +enddelmpp:
>  	mesh_paths_generation++;
>  	spin_unlock(&tbl->hashwlock[hash_idx]);
>  	read_unlock_bh(&pathtbl_resize_lock);

At first I wondered why the last half of the function was changed, but then
I saw that.  Shouldn't the above be "mpp_paths_generation++;"?

In general I'd like to merge these two into one function; the only thing
different is the initial table pointer that gets dereferenced and the
generation counter (and now the labels).  So something like this should
be doable:

static int mesh_table_delete(struct ieee80211_sub_if_data *sdata,
                             struct mesh_table *tbl,
                             const u8 *addr)
{
        /* basically what mesh_path_del is today */
}

int mesh_path_del(...)
{
        tbl = resize_dereference_mesh_paths();
        ret = mesh_table_delete(sdata, tbl, addr);
        mesh_paths_generation++;
        return ret;
}

int mpp_path_del(...)
{
        tbl = resize_dereference_mpp_paths();
        ret = mesh_table_delete(sdata, tbl, addr);
        mpp_paths_generation++;
        return ret;
}

-- 
Bob Copeland %% http://bobcopeland.com/
