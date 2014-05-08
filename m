Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:58339 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbaEHXeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 19:34:14 -0400
Received: by mail-qc0-f171.google.com with SMTP id x13so3699316qcv.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2014 16:34:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399575324-19539-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1399575324-19539-1-git-send-email-rmanohar@qti.qualcomm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 9 May 2014 09:33:52 +1000
Message-ID: <CAGRGNgWPc=3Oyy6n08PEF6ESxvQZM-2+1MaQYSB8vHGAqxgKvg@mail.gmail.com> (sfid-20140509_013418_302366_A1652E26)
Subject: Re: [PATCH] cfg80211: avoid restoring the regulatory during disconnect
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sachin Ahuja <sahuja@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rajkumar,

On Fri, May 9, 2014 at 4:55 AM, Rajkumar Manoharan
<rmanohar@qti.qualcomm.com> wrote:
> From: Sachin Ahuja <sahuja@codeaurora.org>
>
> When STA disconnects, cfg80211 restores the regulatory setting
> to world domain. For the drivers that ignore country ie, cfg80211
> should remain in the default country code which is configured
> at driver load and should do not be restored to world reg domain.
>
> Signed-off-by: Sachin Ahuja <sahuja@codeaurora.org>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
>  net/wireless/sme.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index 4bc21a2..1319dd1 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -558,10 +558,33 @@ static bool cfg80211_is_all_idle(void)
>         return is_all_idle;
>  }
>
> +static bool cfg80211_is_all_countryie_ignore(void)
> +{
> +       struct cfg80211_registered_device *rdev;
> +       struct wireless_dev *wdev;
> +       bool is_all_countryie_ignore = true;
> +
> +       list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
> +               list_for_each_entry(wdev, &rdev->wdev_list, list) {
> +                       wdev_lock(wdev);
> +                       if (!(wdev->wiphy->regulatory_flags &
> +                             REGULATORY_COUNTRY_IE_IGNORE)) {
> +                               is_all_countryie_ignore = false;
> +                               wdev_unlock(wdev);
> +                               goto out;

Why not just return false here and get rid of the bool variable?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
