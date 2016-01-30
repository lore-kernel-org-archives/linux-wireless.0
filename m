Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33537 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbcA3Lzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2016 06:55:50 -0500
MIME-Version: 1.0
In-Reply-To: <20160130055747.GA16656@Karyakshetra>
References: <20160130055747.GA16656@Karyakshetra>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 30 Jan 2016 22:55:29 +1100
Message-ID: <CAGRGNgXSL5a8=Pkx=ipcpaUmCit3NLM7gUhRwE5PD2xCcX-00Q@mail.gmail.com> (sfid-20160130_125610_431008_C143BC12)
Subject: Re: [PATCH v2] staging: rtl8723au: Fixes unnecessary return warning
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Andreas Ruprecht <andreas.ruprecht@fau.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 30, 2016 at 4:57 PM, Bhaktipriya Shridhar
<bhaktipriya96@gmail.com> wrote:
> This patch fixes checkpatch.pl warning in rtw_mlme_ext.c file.
> WARNING: void function return statements are not generally useful
>
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>

Looks sane to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  Changes in v2:
>    - Removed the unnecessary blank lines.
>  drivers/staging/rtl8723au/core/rtw_mlme_ext.c | 20 --------------------
>  1 file changed, 20 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> index d28f29a..7cd0052 100644
> --- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> +++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> @@ -2656,8 +2656,6 @@ static void issue_probersp(struct rtw_adapter *padapter, unsigned char *da)
>         pattrib->last_txcmdsz = pattrib->pktlen;
>
>         dump_mgntframe23a(padapter, pmgntframe);
> -
> -       return;
>  }
>
>  static int _issue_probereq(struct rtw_adapter *padapter,
> @@ -2957,8 +2955,6 @@ static void issue_auth(struct rtw_adapter *padapter, struct sta_info *psta,
>         rtw_wep_encrypt23a(padapter, pmgntframe);
>         DBG_8723A("%s\n", __func__);
>         dump_mgntframe23a(padapter, pmgntframe);
> -
> -       return;
>  }
>
>  #ifdef CONFIG_8723AU_AP_MODE
> @@ -3338,8 +3334,6 @@ exit:
>                 }
>         } else
>                 kfree(pmlmepriv->assoc_req);
> -
> -       return;
>  }
>
>  /* when wait_ack is true, this function should be called at process context */
> @@ -4102,8 +4096,6 @@ static void rtw_site_survey(struct rtw_adapter *padapter)
>                 pmlmeext->chan_scan_time = SURVEY_TO;
>                 pmlmeext->sitesurvey_res.state = SCAN_DISABLE;
>         }
> -
> -       return;
>  }
>
>  /* collect bss info from Beacon and Probe request/response frames. */
> @@ -4759,8 +4751,6 @@ void report_survey_event23a(struct rtw_adapter *padapter,
>         rtw_enqueue_cmd23a(pcmdpriv, pcmd_obj);
>
>         pmlmeext->sitesurvey_res.bss_cnt++;
> -
> -       return;
>  }
>
>  void report_surveydone_event23a(struct rtw_adapter *padapter)
> @@ -4802,8 +4792,6 @@ void report_surveydone_event23a(struct rtw_adapter *padapter)
>         DBG_8723A("survey done event(%x)\n", psurveydone_evt->bss_cnt);
>
>         rtw_enqueue_cmd23a(pcmdpriv, pcmd_obj);
> -
> -       return;
>  }
>
>  void report_join_res23a(struct rtw_adapter *padapter, int res)
> @@ -4850,8 +4838,6 @@ void report_join_res23a(struct rtw_adapter *padapter, int res)
>         rtw_joinbss_event_prehandle23a(padapter, (u8 *)&pjoinbss_evt->network);
>
>         rtw_enqueue_cmd23a(pcmdpriv, pcmd_obj);
> -
> -       return;
>  }
>
>  void report_del_sta_event23a(struct rtw_adapter *padapter,
> @@ -4906,8 +4892,6 @@ void report_del_sta_event23a(struct rtw_adapter *padapter,
>         DBG_8723A("report_del_sta_event23a: delete STA, mac_id =%d\n", mac_id);
>
>         rtw_enqueue_cmd23a(pcmdpriv, pcmd_obj);
> -
> -       return;
>  }
>
>  void report_add_sta_event23a(struct rtw_adapter *padapter,
> @@ -4951,8 +4935,6 @@ void report_add_sta_event23a(struct rtw_adapter *padapter,
>         DBG_8723A("report_add_sta_event23a: add STA\n");
>
>         rtw_enqueue_cmd23a(pcmdpriv, pcmd_obj);
> -
> -       return;
>  }
>
>  /****************************************************************************
> @@ -5394,8 +5376,6 @@ static void link_timer_hdl(unsigned long data)
>                 issue_assocreq(padapter);
>                 set_link_timer(pmlmeext, REASSOC_TO);
>         }
> -
> -       return;
>  }
>
>  static void addba_timer_hdl(unsigned long data)
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
